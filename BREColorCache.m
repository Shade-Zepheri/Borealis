#import "BREColorCache.h"
#import <UIKit/UIImage+Private.h>

@interface BREColorCache () {
    dispatch_queue_t _processingQueue;
}
@property (strong, nonatomic) NSCache<NSString *, UIColor *> *iconCache;
@end

@implementation BREColorCache

#pragma mark - Initialization

+ (instancetype)mainCache {
    static BREColorCache *mainCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mainCache = [[self alloc] init];
    });

    return mainCache;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // Create caches
        _iconCache = [[NSCache alloc] init];
        self.iconCache.countLimit = 23;

        // Create background queue to work on
        dispatch_queue_attr_t attributes = dispatch_queue_attr_make_with_autorelease_frequency(DISPATCH_QUEUE_CONCURRENT, DISPATCH_AUTORELEASE_FREQUENCY_WORK_ITEM);
        dispatch_queue_attr_t calloutAttributes = dispatch_queue_attr_make_with_qos_class(attributes, QOS_CLASS_USER_INITIATED, 0);
        _processingQueue = dispatch_queue_create("com.shade.borealis.color-cache", calloutAttributes);
    }

    return self;
}

#pragma mark - Color Analysis

- (UIColor *)_averageColorForImage:(UIImage *)image {
    CIImage *inputImage = image.CIImage ?: [CIImage imageWithCGImage:image.CGImage];
    if (!inputImage) {
        // No image, fallback
        return [UIColor grayColor];
    }

    CIFilter *filter = [CIFilter filterWithName:@"CIAreaAverage" withInputParameters:@{kCIInputImageKey: inputImage, kCIInputExtentKey: [CIVector vectorWithCGRect:inputImage.extent]}];
    CIImage *outputImage = filter.outputImage;

    UInt8 bitmap[4];
    CIContext *context = [CIContext contextWithOptions:@{kCIContextWorkingColorSpace: [NSNull null]}];
    CGRect bounds  = CGRectMake(0, 0, 1, 1);
    [context render:outputImage toBitmap:&bitmap rowBytes:4 bounds:bounds format:kCIFormatRGBA8 colorSpace:nil];
    return [UIColor colorWithRed:bitmap[0] / 255.0 green:bitmap[1] / 255.0 blue:bitmap[2] / 255.0 alpha:bitmap[3] / 255.0];
}

- (UIColor *)_analyzeIdentifier:(NSString *)identifier {
    // Get icon image
    __block UIColor *averageColor = nil;
    dispatch_sync(_processingQueue, ^{
        // Get color and pass on
        UIImage *appIcon = [UIImage _applicationIconImageForBundleIdentifier:identifier format:0 scale:[UIScreen mainScreen].scale];
        averageColor = [self _averageColorForImage:appIcon];
    });

    // Add to cache
    [self.iconCache setObject:averageColor forKey:identifier];
    return averageColor;
}

#pragma mark - Color Retreval

- (BOOL)hasColorForIdentifier:(NSString *)identifier {
    return [self.iconCache objectForKey:identifier] != nil;
}

- (UIColor *)cachedColorForIdentifier:(NSString *)identifier {
    if ([self hasColorForIdentifier:identifier]) {
        // Simply get and pass to completion
        return [self.iconCache objectForKey:identifier];
    } else {
        // Queue analyzation
        return [self _analyzeIdentifier:identifier];
    }
}

@end
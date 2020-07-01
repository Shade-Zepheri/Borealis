#import "BREColorCache.h"
#import "UIColor+Similar.h"
#import <Palette/Palette.h>
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

- (UIColor *)_primaryColorForImage:(UIImage *)image {
    if (!image) {
        return [UIColor grayColor];
    }

    // Get color palette
    UIImageColorPalette *colorPalette = [image retrieveColorPaletteWithQuality:UIImageResizeQualityMedium];
    UIColor *primaryColor = colorPalette.primary;

    // Analyze color
    if (([primaryColor isSimilarToColor:[UIColor whiteColor]] || [primaryColor isSimilarToColor:[UIColor blackColor]]) && colorPalette.secondary) {
        primaryColor = colorPalette.secondary;
    }

    return primaryColor;
}

- (UIColor *)_analyzeIdentifier:(NSString *)identifier {
    // Get icon image
    __block UIColor *averageColor = nil;
    dispatch_sync(_processingQueue, ^{
        // Get color and pass on
        UIImage *appIcon = [UIImage _applicationIconImageForBundleIdentifier:identifier format:0 scale:[UIScreen mainScreen].scale];
        averageColor = [self _primaryColorForImage:appIcon];
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
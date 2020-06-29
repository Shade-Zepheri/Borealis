#import <UIKit/UIKit.h>

@interface BREColorCache : NSObject
@property (class, strong, readonly) BREColorCache *mainCache;

- (UIColor *)cachedColorForIdentifier:(NSString *)identifier;

@end
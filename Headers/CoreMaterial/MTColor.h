#import <Foundation/Foundation.h>
#import "CoreMaterial+Structs.h"

@interface MTColor : NSObject
+ (instancetype)blackColor;
+ (instancetype)whiteColor;
+ (instancetype)pinkColor;

+ (instancetype)colorWithWhite:(CGFloat)white alpha:(CGFloat)alpha;
+ (instancetype)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
+ (instancetype)colorWithCGColor:(CGColorRef)CGColor;

- (CGColorRef)CGColor;
- (CAColorMatrix)sourceOverColorMatrix;

- (MTColor *)colorWithAlphaComponent:(CGFloat)alpha;
- (MTColor *)colorWithAdditionalAlphaComponent:(CGFloat)alpha;
- (MTColor *)colorBlendedWithColor:(MTColor *)color;

@end
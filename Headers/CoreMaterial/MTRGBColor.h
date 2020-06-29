#import "MTColor.h"

@interface MTRGBColor : MTColor
@property (readonly, nonatomic) CGFloat red;
@property (readonly, nonatomic) CGFloat green;
@property (readonly, nonatomic) CGFloat blue;
@property (readonly, nonatomic) CGFloat alpha;

- (instancetype)initWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

@end
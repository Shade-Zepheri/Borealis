#import "UIColor+Similar.h"

@implementation UIColor (Tetradic)

- (BOOL)isSimilarToColor:(UIColor *)color {
    CGFloat ourRed = 0.0;
    CGFloat ourGreen = 0.0;
    CGFloat ourBlue = 0.0;
    CGFloat ourAlpha = 0.0;
    if (![self getRed:&ourRed green:&ourGreen blue:&ourBlue alpha:&ourAlpha]) {
        return NO;
    }

    CGFloat otherRed = 0.0;
    CGFloat otherGreen = 0.0;
    CGFloat otherBlue = 0.0;
    CGFloat otherAlpha = 0.0;
    if (![color getRed:&otherRed green:&otherGreen blue:&otherBlue alpha:&otherAlpha]) {
        return NO;
    }

    return fabs(ourRed - otherRed) < 0.0902 && fabs(ourGreen - otherGreen) < 0.0902 && fabs(ourBlue - otherBlue) < 0.0902;
}

@end
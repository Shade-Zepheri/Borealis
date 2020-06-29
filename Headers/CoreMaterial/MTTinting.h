#import <Foundation/Foundation.h>
#import "CoreMaterial+Structs.h"

@protocol MTTinting <NSObject>
@property (copy, readonly, nonatomic) NSDictionary *tintColorDescription; 
@property (readonly, nonatomic) CGColorRef tintColor; 
@property (readonly, nonatomic) CGFloat tintAlpha; 

@required

- (CGColorRef)tintColor;
- (NSDictionary *)tintColorDescription;
- (CGFloat)tintAlpha;

@end
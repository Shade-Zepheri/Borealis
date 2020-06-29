#import <Foundation/Foundation.h>
#import "CoreMaterial+Structs.h"

@protocol MTMaterialFiltering <NSObject>
@property (nonatomic,readonly) CGFloat luminanceAmount; 
@property (copy, readonly, nonatomic) NSArray *luminanceValues; 
@property (nonatomic,readonly) CGFloat blurRadius; 
@property (getter=isAverageColorEnabled,nonatomic,readonly) BOOL averageColorEnabled; 
@property (readonly, nonatomic) CGFloat saturation; 
@property (readonly, nonatomic) CGFloat brightness; 
@property (readonly, nonatomic) CAColorMatrix colorMatrix; 
@property (readonly, nonatomic) CGFloat zoom; 
@property (readonly, nonatomic) CGFloat backdropScale; 
@property (copy, readonly, nonatomic) NSString *blurInputQuality; 
@property (getter=isBlurAtEnd, readonly, nonatomic) BOOL blurAtEnd; 

@required

- (CGFloat)saturation;
- (CGFloat)brightness;
- (CGFloat)zoom;
- (CGFloat)blurRadius;
- (NSString *)blurInputQuality;
- (CGFloat)luminanceAmount;
- (NSArray *)luminanceValues;
- (CAColorMatrix)colorMatrix;
- (BOOL)isBlurAtEnd;
- (CGFloat)backdropScale;
- (BOOL)isAverageColorEnabled;

@end
#import <Foundation/Foundation.h>

@protocol MTRecipeMaterialSettingsProviding;
@class MTColor;

@interface MTMaterialSettingsInterpolator : NSObject
@property (nonatomic,retain) id<MTRecipeMaterialSettingsProviding> finalSettings;
@property (nonatomic,copy) NSString *finalConfiguration;
@property (nonatomic,retain) id<MTRecipeMaterialSettingsProviding> initialSettings;
@property (nonatomic,copy) NSString *initialConfiguration;
@property (getter=isTintEnabled, readonly, nonatomic) BOOL tintEnabled;
@property (copy, readonly, nonatomic) MTColor *tintColor;

- (instancetype)initWithSettings:(id<MTRecipeMaterialSettingsProviding>)settings configuration:(NSString *)configuration;

@end
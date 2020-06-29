#import <QuartzCore/CABackdropLayer.h>

@protocol MTRecipeMaterialSettingsProviding;
@class MTMaterialSettingsInterpolator;

@interface MTMaterialLayer : CABackdropLayer 
@property (getter=_recipeSettings, setter=_setRecipeSettings:, strong, nonatomic) id<MTRecipeMaterialSettingsProviding> recipeSettings;

- (void)_configureIfNecessaryWithSettingsInterpolator:(MTMaterialSettingsInterpolator *)settingsInterpolator;

- (void)_setNeedsConfiguring;

@end
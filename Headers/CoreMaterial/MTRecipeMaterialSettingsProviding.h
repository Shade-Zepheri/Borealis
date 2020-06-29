#import <Foundation/Foundation.h>
#import "MTMaterialVersioning.h"

@protocol MTTinting, MTMaterialFiltering;

@protocol MTRecipeMaterialSettingsProviding <MTMaterialVersioning>
@property (readonly, nonatomic) id<MTTinting, MTMaterialFiltering> baseMaterialSettings; 
@property (readonly, nonatomic) id<MTTinting, MTMaterialFiltering> baseOverlaySettings; 
@property (readonly, nonatomic) id<MTTinting, MTMaterialFiltering> primaryOverlaySettings; 
@property (readonly, nonatomic) id<MTTinting, MTMaterialFiltering> secondaryOverlaySettings; 
@property (readonly, nonatomic) id<MTTinting, MTMaterialFiltering> auxiliaryOverlaySettings; 

@required

- (id<MTTinting, MTMaterialFiltering>)baseMaterialSettings;
- (id<MTTinting, MTMaterialFiltering>)baseOverlaySettings;
- (id<MTTinting, MTMaterialFiltering>)primaryOverlaySettings;
- (id<MTTinting, MTMaterialFiltering>)secondaryOverlaySettings;
- (id<MTTinting, MTMaterialFiltering>)auxiliaryOverlaySettings;
- (id<MTTinting, MTMaterialFiltering>)settingsForConfiguration:(NSString *)configuration;

@end
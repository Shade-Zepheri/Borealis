#import "MTTintingMaterialSettings.h"
#import "MTMaterialFiltering.h"

@interface MTTintingFilteringMaterialSettings : MTTintingMaterialSettings <MTMaterialFiltering>

- (instancetype)initWithMaterialDescription:(NSDictionary<NSString *, id> *)materialDescription andDescendantDescriptions:(NSArray<NSDictionary<NSString *, id> *> *)descendantDescriptions;

@end
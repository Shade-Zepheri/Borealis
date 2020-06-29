#import "MTTinting.h"

@interface MTTintingMaterialSettings : NSObject <MTTinting>

- (instancetype)initWithTintingDescription:(NSDictionary<NSString *, id> *)tintingDescription andDescendantDescriptions:(NSArray<NSDictionary<NSString *, id> *> *)descendantDescriptions;

@end
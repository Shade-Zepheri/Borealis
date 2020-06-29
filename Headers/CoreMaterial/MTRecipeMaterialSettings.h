#import "MTRecipeMaterialSettingsProviding.h"

@interface MTRecipeMaterialSettings : NSObject <MTRecipeMaterialSettingsProviding>
@property (readonly, nonatomic) NSInteger materialSettingsVersion;
@property (copy, readonly, nonatomic) NSString *recipeName;
@property (strong, nonatomic) NSDictionary<NSString *, NSString *> *styles;

- (instancetype)initWithRecipeName:(NSString *)recipeName andDescription:(NSDictionary<NSString *, id> *)description descendantDescriptions:(NSArray<NSDictionary<NSString *, id> *> *)descendantDescriptions;

@end
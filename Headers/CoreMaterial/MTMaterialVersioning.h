#import <Foundation/Foundation.h>

@protocol MTMaterialVersioning <NSObject>
@property (readonly, nonatomic) NSInteger materialSettingsVersion;
@property (copy, readonly, nonatomic) NSString *recipeName;

@required

- (NSInteger)materialSettingsVersion;
- (NSString *)recipeName;

@end
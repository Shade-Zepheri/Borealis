#import <QuartzCore/CABackdropLayer.h>
#import "CoreMaterial+Structs.h"

@interface CABackdropLayer (CoreMaterial)

- (void)_mt_setColorMatrix:(CAColorMatrix)colorMatrix withName:(NSString *)name filterOrder:(NSArray<NSString *> *)filterOrder removingIfIdentity:(BOOL)removingIfIdentity;

@end
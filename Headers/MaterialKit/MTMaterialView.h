#import <UIKit/UIKit.h>

@class MTMaterialLayer;

@interface MTMaterialView : UIView
@property (getter=_materialLayer, readonly, nonatomic) MTMaterialLayer *materialLayer;

@end
#import <UIKit/UIKit.h>

@protocol NCNotificationViewControllerDelegate;
@class NCNotificationRequest;

@interface NCNotificationViewController : UIViewController
@property (weak, nonatomic) id<NCNotificationViewControllerDelegate> delegate;
@property (strong, nonatomic) NCNotificationRequest *notificationRequest;

@end

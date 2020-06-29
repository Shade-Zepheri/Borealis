#import "BREColorCache.h"
#import <CoreMaterial/CoreMaterial.h>
#import <MaterialKit/MaterialKit.h>
#import <PlatterKit/PlatterKit.h>
#import <QuartzCore/QuartzCore+Private.h>
#import <UserNotificationsKit/UserNotificationsKit.h>
#import <UserNotificationsUIKit/UserNotificationsUIKit.h>
#import <UIKit/UIKit.h>

#pragma mark - CoverSheet

%hook NCNotificationGroupList

- (NCNotificationListCell *)_cachedCellForNotificationRequest:(NCNotificationRequest *)notificationRequest createNewIfNecessary:(BOOL)createNew shouldConfigure:(BOOL)shouldConfigure {
	// Since cells are reused, this makes sure the colors are properly set
	// Hijack cell
	NCNotificationListCell *resultingCell = %orig;
	NCNotificationViewController *contentViewController = resultingCell.contentViewController;
	if (![contentViewController isKindOfClass:%c(NCNotificationShortLookViewController)]) {
		// Not short look
		return resultingCell;
	}

	NCNotificationShortLookViewController *shortLookViewController = (NCNotificationShortLookViewController *)contentViewController;
	NCNotificationShortLookView *shortLookView = [shortLookViewController _notificationShortLookViewIfLoaded];
	MTMaterialView *materialBackgroundView = shortLookView.backgroundMaterialView;
	MTMaterialLayer *materialLayer = materialBackgroundView.materialLayer;

	// Get color for icon
	NSString *sectionIdentifier = notificationRequest.sectionIdentifier;
	UIColor *averageColor = [[BREColorCache mainCache] cachedColorForIdentifier:sectionIdentifier];
	MTColor *materialColor = [%c(MTColor) colorWithCGColor:averageColor.CGColor];
	MTColor *adjustedMaterialColor = [materialColor colorWithAlphaComponent:0.39];

	// Edit backdrop layer
	[materialLayer _mt_setColorMatrix:adjustedMaterialColor.sourceOverColorMatrix withName:@"opacityColorMatrix" filterOrder:@[@"luminanceMap"] removingIfIdentity:NO];
	[materialLayer setNeedsLayout];

	// Fix corner radius
	materialBackgroundView.clipsToBounds = YES;
	return resultingCell;
}

%end

#pragma mark - Banners

%hook NCNotificationShortLookViewController

- (void)_notificationViewControllerViewDidLoad {
	%orig;

	// Makes sure banners are colored, since they are not under the control of CoverSheet
	NCNotificationShortLookView *shortLookView = [self _notificationShortLookViewIfLoaded];
	MTMaterialView *materialBackgroundView = shortLookView.backgroundMaterialView;
	MTMaterialLayer *materialLayer = materialBackgroundView.materialLayer;

	// Get color for icon
	NSString *sectionIdentifier = self.notificationRequest.sectionIdentifier;
	UIColor *averageColor = [[BREColorCache mainCache] cachedColorForIdentifier:sectionIdentifier];
	MTColor *materialColor = [%c(MTColor) colorWithCGColor:averageColor.CGColor];
	MTColor *adjustedMaterialColor = [materialColor colorWithAlphaComponent:0.39];

	// Edit backdrop layer
	[materialLayer _mt_setColorMatrix:adjustedMaterialColor.sourceOverColorMatrix withName:@"opacityColorMatrix" filterOrder:@[@"luminanceMap"] removingIfIdentity:NO];
	[materialLayer setNeedsLayout];

	// Fix corner radius
	materialBackgroundView.clipsToBounds = YES;
}

%end
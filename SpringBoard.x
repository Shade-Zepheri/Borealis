#import "BREColorCache.h"
#import "BREPreferences.h"
#import <CoreMaterial/CoreMaterial.h>
#import <MaterialKit/MaterialKit.h>
#import <PlatterKit/PlatterKit.h>
#import <QuartzCore/QuartzCore+Private.h>
#import <UserNotificationsKit/UserNotificationsKit.h>
#import <UserNotificationsUIKit/UserNotificationsUIKit.h>
#import <UIKit/UIKit.h>

#pragma mark - CoverSheet

%hook NCNotificationListCache

 - (NCNotificationListCell *)listCellForNotificationRequest:(NCNotificationRequest *)notificationRequest viewControllerDelegate:(id<NCNotificationViewControllerDelegate>)viewControllerDelegate createNewIfNecessary:(BOOL)createNewIfNecessary shouldConfigure:(BOOL)shouldConfigure {
	NCNotificationListCell *resultingCell = %orig;
	BREPreferences *preferences = [BREPreferences sharedPreferences];
	if (!preferences.enabled) {
		// Not enabled
		return resultingCell;
	}

	// Since cells are reused, this makes sure the colors are properly set
	// Hijack cell
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
	MTColor *adjustedMaterialColor = [materialColor colorWithAlphaComponent:0.23];

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

- (instancetype)_initWithNotificationRequest:(NCNotificationRequest *)notificationRequest revealingAdditionalContentOnPresentation:(BOOL)revealingAdditionalContentOnPresentation {
	NCNotificationShortLookViewController *orig = %orig;
	if (orig) {
		// Add observer
		BREPreferences *preferences = [BREPreferences sharedPreferences];
		[preferences addObserver:orig];
	}

	return orig;
}

- (void)dealloc {
	// Remove observer
	BREPreferences *preferences = [BREPreferences sharedPreferences];
	[preferences removeObserver:self];

	%orig;
}

- (void)_notificationViewControllerViewDidLoad {
	%orig;

	// Check if enabled
	BREPreferences *preferences = [BREPreferences sharedPreferences];
	if (!preferences.enabled) {
		return;
	}

	// Makes sure banners are colored, since they are not under the control of CoverSheet
	[self bre_colorizeShortLookView];
}

%new
- (void)bre_colorizeShortLookView {
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

%new
- (void)preferencesDidChange:(BREPreferences *)preferences {
	// Reset view
	if (preferences.enabled) {
		[self bre_colorizeShortLookView];
	} else {
		NCNotificationShortLookView *shortLookView = [self _notificationShortLookViewIfLoaded];
		MTMaterialView *materialBackgroundView = shortLookView.backgroundMaterialView;
		MTMaterialLayer *materialLayer = materialBackgroundView.materialLayer;

		[materialBackgroundView prune];
		[materialLayer _setNeedsConfiguring];
	}
}

%end
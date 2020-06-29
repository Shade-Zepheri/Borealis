#import "NCNotificationShortLookViewController.h"

@class BREPreferences;

@interface NCNotificationShortLookViewController () <BREPreferencesObserver>

- (void)bre_colorizeShortLookView;
- (void)preferencesDidChange:(BREPreferences *)preferences;

@end
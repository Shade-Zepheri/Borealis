#import <UIKit/UIKit.h>

@class BREPreferences;

@protocol BREPreferencesObserver <NSObject>
@required

- (void)preferencesDidChange:(BREPreferences *)preferences;

@end

@interface BREPreferences : NSObject
@property (class, strong, readonly) BREPreferences *sharedPreferences;

@property (getter=isEnabled, readonly, nonatomic) BOOL enabled;

- (void)addObserver:(id<BREPreferencesObserver>)observer;
- (void)removeObserver:(id<BREPreferencesObserver>)observer;

@end
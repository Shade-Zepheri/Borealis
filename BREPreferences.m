#import "BREPreferences.h"
#import <Cephei/HBPreferences.h>

@interface BREPreferences ()
@property (strong, nonatomic) HBPreferences *preferences;
@property (strong, nonatomic) NSHashTable<id<BREPreferencesObserver>> *observers;

@end

@implementation BREPreferences

#pragma mark - Initialization

+ (instancetype)sharedPreferences {
    static BREPreferences *sharedPreferences = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPreferences = [[self alloc] init];
    });

    return sharedPreferences;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // Create defaults
        _observers = [NSHashTable weakObjectsHashTable];

        _preferences = [HBPreferences preferencesForIdentifier:@"com.shade.borealis"];
        [self.preferences registerBool:&_enabled default:YES forKey:@"enabled"];

        // Register callback
        [self.preferences registerPreferenceChangeBlock:^{
            [self notifyObserversOfSettingsChange];
        }];
    }

    return self;
}

#pragma mark - Observers

- (void)addObserver:(id<BREPreferencesObserver>)observer {
    if ([_observers containsObject:observer]) {
        return;
    }

    [_observers addObject:observer];
}

- (void)removeObserver:(id<BREPreferencesObserver>)observer {
    if (![_observers containsObject:observer]) {
        return;
    }

    [_observers removeObject:observer];
}

- (void)notifyObserversOfSettingsChange {
    for (id<BREPreferencesObserver> observer in self.observers) {
        [observer preferencesDidChange:self];
    }
}

@end
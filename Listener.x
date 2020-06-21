#import "Actify.h"

@implementation ActifyListener

+ (void)load {
  @autoreleasepool {
    [[LAActivator sharedInstance] registerListener:[self new] forName:@"com.yulkytulky.actifyListener"];
  }
}

- (NSString *)activator:(LAActivator *)activator requiresLocalizedTitleForListenerName:(NSString *)listenerName {
    return @"Actify";
}
- (NSString *)activator:(LAActivator *)activator requiresLocalizedDescriptionForListenerName:(NSString *)listenerName {
    return @"Display a custom notification from any app";
}
- (NSArray *)activator:(LAActivator *)activator requiresCompatibleEventModesForListenerWithName:(NSString *)listenerName {
    return [NSArray arrayWithObjects:@"springboard", @"lockscreen", @"application", nil];
}
- (UIImage *)activator:(LAActivator *)activator requiresIconForListenerName:(NSString *)listenerName scale:(CGFloat)scale {
	return [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/ActifyPreferences.bundle/icon.png"];
}
- (UIImage *)activator:(LAActivator *)activator requiresSmallIconForListenerName:(NSString *)listenerName scale:(CGFloat)scale {
	return [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/ActifyPreferences.bundle/icon.png"];
}

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {

	[self _showNotificationWithTitle:title message:message fromAppWithBundleID:bundleID];

}

- (void)_showNotificationWithTitle:(NSString *)title message:(NSString *)message fromAppWithBundleID:(NSString *)bundleID {

	void *handle = dlopen("/usr/lib/libnotifications.dylib", RTLD_LAZY);
	if (handle != NULL && [bundleID length] > 0) {                                            
    
		NSString *uid = [[NSUUID UUID] UUIDString];        
  		[%c(CPNotification) showAlertWithTitle:title
							message:message
							userInfo:@{@"" : @""}
							badgeCount:0
							soundName:nil
							delay:1.00
							repeats:NO
							bundleId:bundleID
							uuid:uid
							silent:NO];
					       				       
		dlclose(handle);
	}
}

@end

static void loadPrefs() {

	NSMutableDictionary *preferences = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.yulkytulky.actify.plist"];
	NSMutableDictionary *appListPreferencesBundleID = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.yulkytulky.actify~bundleID.plist"]; // Different plist because using the same plist erased the title and message values

	title = [preferences objectForKey:@"title"] ? [preferences objectForKey:@"title"] : @"";
	message = [preferences objectForKey:@"message"] ? [preferences objectForKey:@"message"] : @"";

	bundleID = [appListPreferencesBundleID objectForKey:@"bundleID"] ? [appListPreferencesBundleID objectForKey:@"bundleID"] : @"";

}

%ctor {

	loadPrefs(); // Load preferences into variables
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.yulkytulky.actify/saved"), NULL, CFNotificationSuspensionBehaviorCoalesce); // Listen for preference changes

}
//--Actify Listener--//
#include <objc/runtime.h>
#include <dlfcn.h>
#include <libactivator/libactivator.h>

//--Preferences Variables--//
NSString *title;
NSString *message;
NSString *bundleID;

//--Interface Declarations--//
@interface CPNotification : NSObject
+ (void)hideAlertWithBundleId:(NSString *)bundleId uuid:(NSString *)uuid;
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message userInfo:(NSDictionary *)userInfo badgeCount:(int)badgeCount soundName:(NSString *)soundName delay:(double)delay repeats:(BOOL)repeats bundleId:(NSString *)bundleId uuid:(NSString *)uuid silent:(BOOL)silent;
@end

@interface ActifyListener : NSObject<LAListener>
@end

//--Actify Tool--//
#include <stdio.h>
#include <unistd.h>

//--Function Declarations--//
void help();
void showNotification(NSString *title, NSString *message, NSString *bundleID);
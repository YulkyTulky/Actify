#import "../Actify.h"

int main(int argc, char *argv[]) {

	if (argc < 2) {
		help();
	}

	char *title = "Title";
	char *message = "Message";
	char *bundleID = "com.apple.Preferences";
	int opt;
	
	while ((opt = getopt(argc, argv, "t:m:b:h")) != -1) {
		switch (opt) {
			case 't':
				title = optarg;
				break;
			case 'm':
				message = optarg;
				break;
			case 'b':
				bundleID = optarg;
				break;
			case 'h':
				help();
			case '?':
				exit(1);
			default:
				break;
    	}
	}

	if (argv[optind]) {
		help();
	}
	
	showNotification([NSString stringWithUTF8String:title], [NSString stringWithUTF8String:message], [NSString stringWithUTF8String:bundleID]);
	
	return 0;

}

void help() {

	printf(
		"\n"
		"Actify - Developed by YulkyTulky (2020)\n"
		"\n"
		"usage: actify [-t title] [-m message] [-b bundleID]\n"
		"	-t   notification title    (default: \"Title\")\n"
		"	-m   notification message  (default: \"Message\")\n"
		"	-b   application bundle ID (default: \"com.apple.Preferences\")\n"
		"	-h   display this help message\n"
		"\n"
		);
	exit(0);

}

void showNotification(NSString *title, NSString *message, NSString *bundleID) {

	void *handle = dlopen("/usr/lib/libnotifications.dylib", RTLD_LAZY);
	if (handle != NULL && [bundleID length] > 0) {  

		NSString *uid = [[NSUUID UUID] UUIDString];        
  		[NSClassFromString(@"CPNotification") showAlertWithTitle:title
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
#import "ScreenCaptureSecure.h"


@implementation ScreenCaptureSecure

static id<NSObject> screenCaptureObserver;

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(sampleMethod:(NSString *)stringArgument numberParameter:(nonnull NSNumber *)numberArgument callback:(RCTResponseSenderBlock)callback)
{
    // TODO: Implement some actually useful functionality
    callback(@[[NSString stringWithFormat: @"numberArgument: %@ stringArgument: %@", numberArgument, stringArgument]]);
}
RCT_EXPORT_METHOD(enableSecure)
{
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    if (screenCaptureObserver == nil) {
    screenCaptureObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationUserDidTakeScreenshotNotification
                                                    object:nil
                                                    queue:mainQueue
                                                usingBlock:^(NSNotification *note) {
                                                    // executes after screenshot
                                                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Caution"
                                                                                message:@"You may be subject to\nlegal sanctions for sharing\nand distributing screenshots\nof your work online or\noffline without permission."
                                                                                preferredStyle:UIAlertControllerStyleAlert];

                                                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action) {}];

                                                    [alert addAction:defaultAction];
                                                    id rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
                                                    if([rootViewController isKindOfClass:[UINavigationController class]])
                                                    {
                                                        rootViewController = ((UINavigationController *)rootViewController).viewControllers.firstObject;
                                                    }
                                                    if([rootViewController isKindOfClass:[UITabBarController class]])
                                                    {
                                                        rootViewController = ((UITabBarController *)rootViewController).selectedViewController;
                                                    }

                                                    [rootViewController presentViewController:alert animated:YES completion:nil];
                                                }];
    }
}

RCT_EXPORT_METHOD(disableSecure)
{
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    if (screenCaptureObserver != nil) {
        [[NSNotificationCenter defaultCenter] removeObserver: screenCaptureObserver];
    }
    screenCaptureObserver = nil;
}
@end


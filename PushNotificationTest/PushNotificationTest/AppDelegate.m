//
//  AppDelegate.m
//  PushNotificationTest
//
//  Created by Eugene Kuropatenko on 29.10.15.
//  Copyright © 2015 Eugene Kuropatenko. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        BOOL isRegisteredForPush = [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
        
        if (!isRegisteredForPush) {
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIRemoteNotificationTypeNewsstandContentAvailability) categories:nil]];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeNewsstandContentAvailability)];
    }
    
    
    return YES;
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
     [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:kDeviceToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:kReceiveTokenNotification object:nil];
    NSLog(@"Token %@",deviceToken);
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kDeviceToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)openInAppFromPushNotificationWithApplication:(UIApplication *)application andUserInfo:(NSDictionary *)userInfo withComplationHandler:(void(^)(UIBackgroundFetchResult completionHandler))completionHandlerResult
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kReceiveNotification object:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kReceiveNotification object:userInfo];
}

@end

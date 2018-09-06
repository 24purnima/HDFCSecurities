//
//  AppDelegate.m
//  Kotak Wealth Watch App
//
//  Created by Rajeev Ranjan on 01/09/17.
//  Copyright © 2017 Shephertz Technologies. All rights reserved.
//

#import "AppDelegate.h"
#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>
#import <Shephertz_App42_iOS_API/App42IAMService.h>

#import <UserNotifications/UserNotifications.h>
#import "StocksListViewController.h"


#define APP42_APP_KEY @"bf1587bf4f9cabd156e87c1be4b73af773edd60c236f9a86922afe3ab65bb2b0"
#define APP42_SECRET_KEY @"253f0841bf6851071fed40f03283aa8ffd7df879cd4e592ed464d7de2dfccd56"

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [App42API setLoggedInUser:@"SushilBhadauria"];
    [App42API initializeWithAPIKey:APP42_APP_KEY andSecretKey:APP42_SECRET_KEY];
    

//    [App42API setLoggedInUser:@"iosWatchUser"];
    
    [App42API setBaseUrl:@"https://in-api.shephertz.com"];
    [App42API setEventBaseUrl:@"https://in-analytics.shephertz.com"];
    [App42API enableApp42Trace:YES]; //Enable to see SDK internal logs
    [App42API enableEventService:YES];
    [App42API enableAppStateEventTracking:YES];
    
    
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0xe31e24)];
    [[UINavigationBar appearance] setTranslucent:false];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UIBarButtonItem appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:    [UIColor whiteColor], UITextAttributeTextColor,
                                                    [UIFont boldSystemFontOfSize:16.0f], UITextAttributeFont,
                                                    [UIColor whiteColor], UITextAttributeTextShadowColor,
                                                    [NSValue valueWithCGSize:CGSizeMake(0.0, -1.0)], UITextAttributeTextShadowOffset,
                                                    nil] forState:UIControlStateNormal];
    
//    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0xECEBF3);
//    self.navigationController.navigationBar.translucent = NO;
    
    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")){
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge)
         
                              completionHandler:^(BOOL granted, NSError * _Nullable error){
                                  if(!error){
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [[UIApplication sharedApplication] registerForRemoteNotifications];
                                      });
                                  }
                              }];
    }
    else{
        if ([application respondsToSelector:@selector(registerUserNotificationSettings:)])
        {
            UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                            UIUserNotificationTypeBadge |
                                                            UIUserNotificationTypeSound);
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                     categories:nil];
//            [application registerUserNotificationSettings:settings];
            
        }
        else
        {
            // Register for Push Notifications, if running iOS version < 8
            [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                             UIRemoteNotificationTypeAlert |
                                                             UIRemoteNotificationTypeSound)];
        }
    }
    
    
    
    return YES;
}

-(void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"My token is: %@", deviceToken);
    // Prepare the Device Token for Registration (remove spaces and < >)
    NSString *devToken = [[[[deviceToken description]
                            stringByReplacingOccurrencesOfString:@"<"withString:@""]
                           stringByReplacingOccurrencesOfString:@">" withString:@""]
                          stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    NSLog(@"My token is: %@", devToken);
//    [self registerDeviceToken:devToken];
//    [self.stocksListVC registerDeviceToken:devToken];
    
//    [self.loginVC setDeviceTokenString:devToken];
    [self.loginVC setDeviceToken:devToken];
    NSLog(@"device token: %@", self.loginVC.deviceToken);
}


#pragma mark- Push related delagates

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    NSLog(@"%s....%@",__FUNCTION__,notificationSettings);
    [application registerForRemoteNotifications];
    
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"%s ..error=%@",__FUNCTION__,error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"%s ..userInfo=%@",__FUNCTION__,userInfo);
    
//    [_viewController updatePushMessageLabel:[userInfo JSONRepresentation]];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"%s ..userInfo=%@",__FUNCTION__,userInfo);
    /**
     * Handles the geo based push messages and decides the eligibility of the push that should be shown to user or not
     */
//    [[App42PushManager sharedManager] handleGeoBasedPush:userInfo fetchCompletionHandler:completionHandler];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

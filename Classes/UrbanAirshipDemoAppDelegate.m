//
//  UrbanAirshipDemoAppDelegate.m
//  UrbanAirshipDemo
//
//  Created by Charles Joseph Uy on 12/1/10.
//  Copyright 2010 G2iX. All rights reserved.
//

#import "UrbanAirshipDemoAppDelegate.h"
#import "ASIHTTPRequest.h"
#import "JSON.h"

@implementation UrbanAirshipDemoAppDelegate

@synthesize window;


#pragma mark -
#pragma mark UrbanAirship 

- (BOOL)registerDeviceTokenToUrbanAirship:(NSData *)deviceToken {
    NSURL *registrationURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/api/device_tokens/%@", URBANAIRSHIP, [deviceToken description]]];
    ASIHTTPRequest *registrationRequest = [[ASIHTTPRequest alloc] initWithURL:registrationURL];
    [registrationURL release];
    registrationRequest.username = APPLICATION_KEY;
    registrationRequest.password = APPLICATION_SECRET;
    
    NSDictionary *jsonContent = [NSDictionary dictionaryWithObjectsAndKeys:@"userAlias", @"alias", nil];
    NSMutableData *postData = [[NSMutableData alloc] initWithData:[[jsonContent JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding]];
    registrationRequest.postBody = postData;
    
    [registrationRequest start];
    
    BOOL registrationSuccess = [registrationRequest responseStatusCode] == 200 | [registrationRequest responseStatusCode] == 201;
    NSLog(@"registration responseString = %@", [registrationRequest responseString]);
    
    [registrationRequest release];
    return registrationSuccess;
}


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];    
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


#pragma mark -
#pragma mark Remote Notification Delegates

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [deviceToken retain];
    [_deviceToken release];
    _deviceToken = deviceToken;
    _registered = [self registerDeviceTokenToUrbanAirship:deviceToken];
    if (_registered) {
        // do something
    }
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Error in registration. Error: %@", error);
}

@end

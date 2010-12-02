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

#define TEXT_LAUNCHED_WITH_OPTIONS      @"Application launched with options:"
#define TEXT_HAS_REMOTE_NOTIFICATION    @"Has Remote Notification:"
#define TEXT_HAS_LOCAL_NOTIFICATION     @"Has Local Notification:"
#define TEXT_LAST_REGISTERED            @"Registration:"

#define TAG_LAUNCHED_WITH_OPTIONS   101
#define TAG_HAS_REMOTE_NOTIFICATION 102
#define TAG_HAS_LOCAL_NOTIFICATION  103
#define TAG_LAST_REGISTERED         104

@implementation UrbanAirshipDemoAppDelegate

@synthesize window;


#pragma mark -
#pragma mark UrbanAirship 

- (BOOL)registerDeviceTokenToUrbanAirship:(NSString *)deviceTokenString {
    NSString *urlString = [NSString stringWithFormat:@"%@/api/device_tokens/%@", URBANAIRSHIP, deviceTokenString];
    NSURL *registrationURL = [[NSURL alloc] initWithString:urlString];

    ASIHTTPRequest *registrationRequest = [[ASIHTTPRequest alloc] initWithURL:registrationURL];
    [registrationURL release];
    registrationRequest.username = APPLICATION_KEY;
    registrationRequest.password = APPLICATION_SECRET;
    
    NSDictionary *jsonContent = [NSDictionary dictionaryWithObjectsAndKeys:@"userAlias", @"alias", nil];
    [registrationRequest appendPostData:[[jsonContent JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding]];
    [registrationRequest addRequestHeader:@"Content-Type" value:@"application/json"];
    [registrationRequest setRequestMethod:@"PUT"];

    [registrationRequest startSynchronous];
    
    BOOL registrationSuccess = [registrationRequest responseStatusCode] == 200 || [registrationRequest responseStatusCode] == 201;
    [registrationRequest release];
    return registrationSuccess;        
}

- (NSDictionary *)getDeviceTokenInformation:(NSString *)deviceTokenString {
    NSURL *deviceTokenInfoURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/api/device_tokens/%@", URBANAIRSHIP, deviceTokenString]];
    ASIHTTPRequest *deviceTokenInfoRequest = [[ASIHTTPRequest alloc] initWithURL:deviceTokenInfoURL];
    [deviceTokenInfoURL release];
    deviceTokenInfoRequest.username = APPLICATION_KEY;
    deviceTokenInfoRequest.password = APPLICATION_SECRET;
    
    [deviceTokenInfoRequest startSynchronous];
    
    NSDictionary *responseDictionary = [[deviceTokenInfoRequest responseString] JSONValue];
    
    [deviceTokenInfoRequest release];
    return responseDictionary;    
}


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    UILabel *launchedWithOptionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.bounds.size.width, 44)];
    launchedWithOptionsLabel.tag = TAG_LAUNCHED_WITH_OPTIONS;
    launchedWithOptionsLabel.text = [NSString stringWithFormat:@"%@ NO", TEXT_LAUNCHED_WITH_OPTIONS];
    UILabel *hasRemoteNotificationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, view.bounds.size.width, 44)];
    hasRemoteNotificationLabel.tag = TAG_HAS_REMOTE_NOTIFICATION;
    hasRemoteNotificationLabel.text = [NSString stringWithFormat:@"%@ NO", TEXT_HAS_REMOTE_NOTIFICATION];
    UILabel *hasLocalNotificationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 88, view.bounds.size.width, 44)];
    hasLocalNotificationLabel.tag = TAG_HAS_LOCAL_NOTIFICATION;
    hasLocalNotificationLabel.text = [NSString stringWithFormat:@"%@ NO", TEXT_HAS_LOCAL_NOTIFICATION];
    UILabel *lastRegisteredLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 132, view.bounds.size.width, 44)];
    lastRegisteredLabel.tag = TAG_LAST_REGISTERED;
    lastRegisteredLabel.text = [NSString stringWithFormat:@"%@ Unknown", TEXT_LAST_REGISTERED];
    
    [view addSubview:launchedWithOptionsLabel];
    [view addSubview:hasRemoteNotificationLabel];
    [view addSubview:hasLocalNotificationLabel];
    [view addSubview:lastRegisteredLabel];
    [lastRegisteredLabel release];
    [hasLocalNotificationLabel release];
    [hasRemoteNotificationLabel release];
    [launchedWithOptionsLabel release];
    
    [window addSubview:view];
    [view release];
    
    [self.window makeKeyAndVisible];
    if (launchOptions) {
        UILabel *launchOptionsLabel = (UILabel *)[window viewWithTag:TAG_LAUNCHED_WITH_OPTIONS];
        launchOptionsLabel.text = [NSString stringWithFormat:@"%@ YES", TEXT_LAUNCHED_WITH_OPTIONS];
        UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
        if (localNotification) {
            UILabel *localLabel = (UILabel *)[window viewWithTag:TAG_HAS_LOCAL_NOTIFICATION];
            localLabel.text = [NSString stringWithFormat:@"%@ YES", TEXT_HAS_LOCAL_NOTIFICATION];
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;            
        }
        NSDictionary *remoteNotificationInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (remoteNotificationInfo) {
            UILabel *remoteLabel = (UILabel *)[window viewWithTag:TAG_HAS_REMOTE_NOTIFICATION];
            remoteLabel.text = [NSString stringWithFormat:@"%@ YES", TEXT_HAS_REMOTE_NOTIFICATION];
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;            
        }        
    }

    // Handle notifications
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];    
    
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
    _deviceTokenString = [[[[[[deviceToken description] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] uppercaseString] retain];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        _registered = [self registerDeviceTokenToUrbanAirship:_deviceTokenString];
        if (_registered) {
            NSDictionary *deviceTokenInfo = [self getDeviceTokenInformation:_deviceTokenString];
            dispatch_async(dispatch_get_main_queue() , ^{
                UILabel *lastRegisteredLabel = (UILabel *)[window viewWithTag:TAG_LAST_REGISTERED];
                lastRegisteredLabel.text = [NSString stringWithFormat:@"%@ %@", TEXT_LAST_REGISTERED, [deviceTokenInfo valueForKey:@"last_registration"]];
            });
        }
    });
}


- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Error in registration. Error: %@", error);
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    UILabel *localLabel = (UILabel *)[window viewWithTag:TAG_HAS_LOCAL_NOTIFICATION];
    localLabel.text = [NSString stringWithFormat:@"%@ YES", TEXT_HAS_LOCAL_NOTIFICATION];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    UILabel *remoteLabel = (UILabel *)[window viewWithTag:TAG_HAS_REMOTE_NOTIFICATION];
    remoteLabel.text = [NSString stringWithFormat:@"%@ YES", TEXT_HAS_REMOTE_NOTIFICATION];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}


@end

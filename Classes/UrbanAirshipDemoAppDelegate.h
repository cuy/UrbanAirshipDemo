//
//  UrbanAirshipDemoAppDelegate.h
//  UrbanAirshipDemo
//
//  Created by Charles Joseph Uy on 12/1/10.
//  Copyright 2010 G2iX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UrbanAirshipDemoConstants.h"

@interface UrbanAirshipDemoAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    NSData *_deviceToken;
    BOOL _registered;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end


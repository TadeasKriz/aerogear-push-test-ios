//
//  TabBarController.h
//  aerogear-push-test-ios
//
//  Created by TadeasKriz on 8/23/13.
//
//

#import <UIKit/UIKit.h>

@interface TabBarController : UITabBarController

- (void)remoteNotificationReceived:(NSDictionary*)data;

@end

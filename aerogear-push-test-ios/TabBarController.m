//
//  TabBarController.m
//  aerogear-push-test-ios
//
//  Created by TadeasKriz on 8/23/13.
//
//

#import "TabBarController.h"

#import "BaseTabController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)remoteNotificationReceived:(NSDictionary*)data {
    BaseTabController* selected = (BaseTabController*) [self selectedViewController];
    
    [selected remoteNotificationReceived:data];
}

@end

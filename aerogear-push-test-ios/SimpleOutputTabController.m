//
//  SimpleOutputTabController.m
//  aerogear-push-test-ios
//
//  Created by TadeasKriz on 8/23/13.
//
//

#import "SimpleOutputTabController.h"

#import "ViewController.h"

@interface SimpleOutputTabController ()

@end

@implementation SimpleOutputTabController

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

- (void)viewDidUnload {
    [self setOutput:nil];
    [self setOutput:nil];
    [super viewDidUnload];
}

- (void)remoteNotificationReceived:(NSDictionary *)data {
    NSString* json = [ViewController convertDictionaryToJsonString: data];
    
    [self.output setText:json];
}
@end

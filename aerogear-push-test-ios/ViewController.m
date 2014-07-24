//
//  ViewController.m
//  aerogear-push-test-ios
//
//  Created by TadeasKriz on 7/19/13.
//
//

#import "ViewController.h"
#import "TabBarController.h"

#import <AGDeviceRegistration.h>
#import <AFNetworking.h>

@interface ViewController ()

@end

@implementation ViewController

@synthesize deviceToken;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return NO;
}

- (IBAction)register:(id)sender {
    [self.registerButton setEnabled: NO];
    
    AGDeviceRegistration *registration = [[AGDeviceRegistration alloc] initWithServerURL:[NSURL URLWithString:self.pushServer.text]];
    
    [registration registerWithClientInfo:^(id<AGClientDeviceInformation> clientInfo) {
        [clientInfo setVariantID:self.variantId.text];
        [clientInfo setDeviceToken:self.deviceToken];
        [clientInfo setVariantSecret:self.secret.text];
        
    } success:^() {
        [self.registerButton setTitle:@"Registered" forState:UIControlStateDisabled];
        
        TabBarController* tabController = [[self storyboard] instantiateViewControllerWithIdentifier:@"TabBarViewController"];
        
        [self presentModalViewController:tabController animated:YES];
    } failure:^(NSError *error) {
        [self.registerButton setEnabled:true];
        [self.output setText:[NSString stringWithFormat: @"PushEE registration error: %@", error]];
    }];
    
}

- (IBAction)preload:(id)sender {

    [self.preloadButton setEnabled: NO];

    
    NSURL* url = [NSURL URLWithString:self.preloadUrl.text];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation* operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"Success");
        
        NSString* pushServer = [JSON valueForKeyPath:@"url"];
        if(pushServer != nil) {
            [self.pushServer setText: pushServer];
        }
            
        NSString* variantID = [JSON valueForKeyPath:@"variantID"];
        if(variantID != nil) {
            [self.variantId setText: variantID];
        }
        
        NSString* secret = [JSON valueForKeyPath:@"secret"];
        if(secret != nil) {
        [self.secret setText: secret];
        }
        
        NSString* alias = [JSON valueForKeyPath:@"alias"];
        if(alias != nil) {
            [self.alias setText: alias];
        }
        
        [self.preloadButton setEnabled: YES];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Failure");
        [self.preloadButton setEnabled: YES];
    }];
    [operation start];
}

- (void)remoteNotificationReceived:(NSDictionary *)data {
    TabBarController* tabController = (TabBarController*) [self modalViewController];
    
    [tabController remoteNotificationReceived: data];
    return;
    
    NSString* json = [ViewController convertDictionaryToJsonString:data];
    
    [self.output setText:json];
    
}

+(NSString*)convertDictionaryToJsonString:(NSDictionary*)data {
    NSError* error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&error];
    
    if(!jsonData) {
        NSLog(@"Got an error: %@", error);
        return nil;
    }
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
- (void)viewDidUnload {
    [self setPreloadUrl:nil];
    [self setPreloadUrl:nil];
    [self setPreloadButton:nil];
    [super viewDidUnload];
}
@end
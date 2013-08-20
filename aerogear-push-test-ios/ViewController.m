//
//  ViewController.m
//  aerogear-push-test-ios
//
//  Created by TadeasKriz on 7/19/13.
//
//

#import "ViewController.h"

#import <AGDeviceRegistration.h>

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
    [self.registerButton setEnabled:false];
    
    AGDeviceRegistration *registration = [[AGDeviceRegistration alloc] initWithServerURL:[NSURL URLWithString:self.pushServer.text]];
    
    [registration registerWithClientInfo:^(id<AGClientDeviceInformation> clientInfo) {
        [clientInfo setVariantID:self.variantId.text];
        [clientInfo setDeviceToken:self.deviceToken];
        [clientInfo setVariantSecret:self.secret.text];
        
    } success:^() {
        [self.registerButton setTitle:@"Registered" forState:UIControlStateDisabled];
    } failure:^(NSError *error) {
        [self.registerButton setEnabled:true];
        [self.output setText:[NSString stringWithFormat: @"PushEE registration error: %@", error]];
    }];
    
}

- (void)remoteNotificationReceived:(NSDictionary *)data {
    NSString* json = [self convertDictionaryToJsonString:data];
    
    if(![self.appendNewMessages isOn] || [self.output.text hasPrefix:@"New messages"]) {
        [self.output setText:json];
    } else {
        [self.output setText:[self.output.text stringByAppendingFormat:@"\n\n%@",json]];
    }
}

-(NSString*)convertDictionaryToJsonString:(NSDictionary*)data {
    NSError* error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&error];
    
    if(!jsonData) {
        NSLog(@"Got an error: %@", error);
        return nil;
    }
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
@end
//
//  ViewController.h
//  aerogear-push-test-ios
//
//  Created by TadeasKriz on 7/19/13.
//
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *pushServer;
@property (weak, nonatomic) IBOutlet UITextField *variantId;
@property (weak, nonatomic) IBOutlet UITextField *secret;
@property (weak, nonatomic) IBOutlet UITextField *alias;
@property (weak, nonatomic) IBOutlet UISwitch *appendNewMessages;
@property (weak, nonatomic) IBOutlet UILabel *output;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@property (copy, nonatomic) NSData *deviceToken;

- (IBAction)register:(id)sender;
- (void)remoteNotificationReceived:(NSDictionary *)data;
@end

//
//  PerformanceOutputTabController.h
//  aerogear-push-test-ios
//
//  Created by TadeasKriz on 8/23/13.
//
//

#import <UIKit/UIKit.h>

#import "BaseTabController.h"
#import "PushMessageDeliveryReport.h"

@interface PerformanceOutputTabController : BaseTabController
@property (atomic) PushMessageDeliveryReport* deliveryReport;

@property (weak, nonatomic) IBOutlet UIButton *statsButton;
@property (weak, nonatomic) IBOutlet UITextView *output;

- (IBAction)stats:(id)sender;
- (IBAction)reset:(id)sender;

@end

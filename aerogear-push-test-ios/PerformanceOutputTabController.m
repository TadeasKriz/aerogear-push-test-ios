//
//  PerformanceOutputTabController.m
//  aerogear-push-test-ios
//
//  Created by TadeasKriz on 8/23/13.
//
//

#import "PerformanceOutputTabController.h"

#import "ViewController.h"

@interface PerformanceOutputTabController ()

@end

@implementation PerformanceOutputTabController

@synthesize deliveryReport;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setDeliveryReport:[[PushMessageDeliveryReport alloc] init]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setStatsButton:nil];
    [self setOutput:nil];
    [self setOutput:nil];
    [super viewDidUnload];
}

- (void)remoteNotificationReceived:(NSDictionary *)data {
    NSNumber* agent = [data objectForKey:@"agent"];
    NSNumber* process = [data objectForKey:@"process"];
    NSNumber* thread = [data objectForKey:@"thread"];
    NSNumber* run = [data objectForKey:@"run"];
    
    [deliveryReport deliveredByAgent:[agent integerValue] byProcess:[process integerValue] byThread:[thread integerValue] inRun:[run integerValue]];
    
    if(![[self statsButton] isSelected]) {
        NSString* json = [ViewController convertDictionaryToJsonString:data];
        [self.output setText:json];
    }
}

- (IBAction)stats:(id)sender {
    if([self.statsButton isSelected]) {
        [self.statsButton setSelected:false];
        [self.output setText:@""];
    } else {
        [self.statsButton setSelected:true];
        
        NSMutableArray* missingMessages = [deliveryReport missingMessages];
        
        NSMutableString* string = [NSMutableString stringWithFormat:@"Total delivered messages: %ld", (long)[[deliveryReport totalDeliveredMessages] longValue]];
        
        NSUInteger missingCount = [missingMessages count];
        if(missingCount > 0) {
            [string appendFormat:@"\n\nTotal missing messages: %lu", (unsigned long) missingCount];
            
            for(unsigned long i = 0; i < missingCount; i++) {
                [string appendFormat:@"\n%d", [missingMessages[i] intValue]];
            }
        }
        
        [self.output setText:string];
    }

}


- (IBAction)reset:(id)sender {
    [deliveryReport reset];
}
@end

//
//  PushMessageDeliveryReport.h
//  aerogear-push-test-ios
//
//  Created by TadeasKriz on 8/23/13.
//
//

#import <Foundation/Foundation.h>

@interface PushMessageDeliveryReport : NSObject

@property (atomic) CFMutableBitVectorRef bitmap;
@property (atomic) NSNumber* totalDeliveredMessages;
@property (atomic) NSInteger maxAgent;
@property (atomic) NSInteger maxProcess;
@property (atomic) NSInteger maxThread;
@property (atomic) NSInteger maxRun;

- (void)reset;

- (void)deliveredByAgent:(NSInteger)agent byProcess:(NSInteger)process byThread:(NSInteger)thread inRun:(NSInteger)run;

- (NSMutableArray*)missingMessages;

- (NSNumber*)indexByAgent:(NSInteger)agent byProcess:(NSInteger)process byThread:(NSInteger)thread inRun:(NSInteger)run;



@end

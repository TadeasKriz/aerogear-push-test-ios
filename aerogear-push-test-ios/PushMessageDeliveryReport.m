//
//  PushMessageDeliveryReport.m
//  aerogear-push-test-ios
//
//  Created by TadeasKriz on 8/23/13.
//
//

#import "PushMessageDeliveryReport.h"

@implementation PushMessageDeliveryReport

static const NSInteger RUN_MAX = 4096; // 2 ^ 12
static const NSInteger THREAD_MAX = 64; // 2 ^ 6
static const NSInteger PROCESS_MAX = 64; // 2 ^ 6
static const NSInteger AGENT_MAX = 4; // 2 ^ 2

static const NSInteger RUN_OFFSET = 1;
static const NSInteger THREAD_OFFSET = RUN_MAX;
static const NSInteger PROCESS_OFFSET = THREAD_MAX * THREAD_OFFSET;
static const NSInteger AGENTS_OFFSET = PROCESS_MAX * PROCESS_OFFSET;

static const NSInteger TOTAL_BITS = AGENT_MAX * AGENTS_OFFSET;


@synthesize bitmap;
@synthesize totalDeliveredMessages;
@synthesize maxAgent;
@synthesize maxProcess;
@synthesize maxThread;
@synthesize maxRun;

- (id)init
{
    self = [super init];
    if (self) {
        [self reset];
    }
    return self;
}

- (void) reset {
    if(bitmap != nil) {
        CFRelease(bitmap);
    }
    [self setBitmap:CFBitVectorCreateMutable(kCFAllocatorDefault, TOTAL_BITS)];
    [self setTotalDeliveredMessages:0];
    [self setMaxAgent:0];
    [self setMaxProcess:0];
    [self setMaxThread:0];
    [self setMaxRun:0];
}

- (void) deliveredByAgent:(NSInteger)agent byProcess:(NSInteger)process byThread:(NSInteger)thread inRun:(NSInteger)run {
    @synchronized(totalDeliveredMessages) {

        if(agent >= AGENT_MAX || process >= PROCESS_MAX || thread >= THREAD_MAX || run >= RUN_MAX) {
            [NSException raise:@"Invalid delivery!" format:@"Invalid agent %d, process %d, thread %d or run number %d",
                            agent, process, thread, run];
        }

        totalDeliveredMessages = @([totalDeliveredMessages intValue] + 1);
    
        [self setMaxAgent: agent > maxAgent ? agent : maxAgent];
        [self setMaxProcess: process > maxProcess ? process : maxProcess];
        [self setMaxThread: thread > maxThread ? thread : maxThread];
        [self setMaxRun: run > maxRun ? run : maxRun];
    
        NSNumber* index = [self indexByAgent:agent byProcess:process byThread:thread inRun:run];
    
        CFBitVectorSetBitAtIndex(bitmap, [index intValue], 1);
    }
}

- (NSMutableArray*) missingMessages {
    NSMutableArray* missingMessages = [[NSMutableArray alloc] init];
    
    if([totalDeliveredMessages intValue] > 0) {
        for(int agent = 0; agent <= maxAgent; agent++) {
            for(int process = 0; process <= maxProcess; process++) {
                for(int thread = 0; thread <= maxThread; thread++) {
                    for(int run = 0; run <= maxRun; run++) {
                        NSNumber* index = [self indexByAgent:agent byProcess:process byThread:thread inRun:run];
                        
                        if(!CFBitVectorGetBitAtIndex(bitmap, [index intValue])) {
                            [missingMessages addObject:index];
                        }
                    }
                }
            }
        }
    }
    
    return missingMessages;
}

- (NSNumber*) indexByAgent:(NSInteger)agent byProcess:(NSInteger)process byThread:(NSInteger)thread inRun:(NSInteger)run {
    return @(AGENTS_OFFSET * agent + PROCESS_OFFSET + (process + THREAD_MAX) + THREAD_OFFSET * thread + RUN_OFFSET * run);
}

@end

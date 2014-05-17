#import <XCTest/XCTest.h>
#import <Stubble/Stubble.h>
#import "TFFReachabilityTargetAction.h"

@interface Fake1 : NSObject
- (void)becameReachable;
@end
@implementation Fake1
- (void)becameReachable {}
@end

#pragma mark -

@interface Fake2 : NSObject
- (void)reachabilityChanged:(TFFReachabilityStatus)status;
@end
@implementation Fake2
- (void)reachabilityChanged:(TFFReachabilityStatus)status {}
@end

#pragma mark -

@interface TFFReachabilityTargetActionTests : XCTestCase
@property (nonatomic) TFFReachabilityTargetAction *testObject;
@end

@implementation TFFReachabilityTargetActionTests

- (void)testReachabilityChangeCallsEachTarget
{
    Fake1 *mockTarget1 = SBLMock([Fake1 class]);
    Fake2 *mockTarget2 = SBLMock([Fake2 class]);
    Fake1 *mockTarget3 = SBLMock([Fake1 class]);

    self.testObject = [[TFFReachabilityTargetAction alloc] init];
    
    [self.testObject addTarget:mockTarget1
                        action:@selector(becameReachable)
                     forStatus:TFFReachabilityStatusReachable];
    
    [self.testObject addTarget:mockTarget2
                        action:@selector(reachabilityChanged:)
                     forStatus:TFFReachabilityStatusNotReachable|TFFReachabilityStatusReachable];
    
    [self.testObject addTarget:mockTarget3
                        action:@selector(becameReachable)
                     forStatus:TFFReachabilityStatusReachable];
    
    [self.testObject removeTarget:mockTarget3
                           action:@selector(becameReachable)
                        forStatus:TFFReachabilityStatusReachable];
    
    [self.testObject startMonitoring];
    
    SBLVerify([mockTarget1 becameReachable]);
    SBLVerify([mockTarget2 reachabilityChanged:SBLAny(TFFReachabilityStatus)]);
    SBLVerifyNever([mockTarget3 becameReachable]);
}

@end

#import <XCTest/XCTest.h>
#import "TFFReachabilityBlock.h"

@interface TFFReachabilityBlockTests : XCTestCase
@property (nonatomic) TFFReachabilityBlock *testObject;
@end

@implementation TFFReachabilityBlockTests

- (void)testReachabilityStatusChangedBlock
{
    self.testObject = [[TFFReachabilityBlock alloc] init];

    __block BOOL blockCalled = NO;
    [self.testObject setReachabilityStatusChangedBlock:^(TFFReachabilityStatus status){
        blockCalled = YES;
    }];
    
    [self.testObject startMonitoring];
    
    XCTAssertTrue(blockCalled);
}

@end

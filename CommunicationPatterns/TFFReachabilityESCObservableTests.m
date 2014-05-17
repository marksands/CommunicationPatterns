#import <XCTest/XCTest.h>
#import <Stubble/Stubble.h>
#import "TFFReachabilityESCObservable.h"

@interface TFFReachabilityESCObservableTests : XCTestCase
@property (nonatomic) TFFReachabilityESCObservable *testObject;
@end

@implementation TFFReachabilityESCObservableTests

- (void)testReachabilityESCObservable {
    self.testObject = [[TFFReachabilityESCObservable alloc] init];
    
    id<TFFReachabilityObserver> mock1 = SBLMock(@protocol(TFFReachabilityObserver));
    [self.testObject escAddObserver:mock1];

    id<TFFReachabilityObserver> mock2 = SBLMock(@protocol(TFFReachabilityObserver));
    [self.testObject escAddObserver:mock2];
    
    [self.testObject startMonitoring];
    
    SBLVerify([mock1 networkStatusChanged:SBLAny(TFFReachabilityStatus)]);
    SBLVerify([mock2 networkStatusChanged:SBLAny(TFFReachabilityStatus)]);}

@end

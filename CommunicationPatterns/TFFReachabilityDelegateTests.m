#import <XCTest/XCTest.h>
#import <Stubble/Stubble.h>
#import "TFFReachabilityDelegate.h"

@interface TFFReachabilityDelegateTests : XCTestCase
@property (nonatomic) TFFReachabilityDelegate *testObject;
@end

@implementation TFFReachabilityDelegateTests

- (void)testReachabilityDelegate
{
    id<TFFReachabilityDelegate> mockDelegate = SBLMock(@protocol(TFFReachabilityDelegate));
    
    self.testObject = [[TFFReachabilityDelegate alloc] init];
    
    self.testObject.delegate = mockDelegate;
    
    [self.testObject startMonitoring];
    
    SBLVerify([mockDelegate networkStatusChanged:SBLAny(TFFReachabilityStatus)]);
}

@end

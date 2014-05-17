#import <XCTest/XCTest.h>
#import "TFFReachabilityNotification.h"

@interface TFFReachabilityNotificationTests : XCTestCase
@property (nonatomic) TFFReachabilityNotification *testObject;
@end

@implementation TFFReachabilityNotificationTests

- (void)testReachabilityNotification
{
    self.testObject = [[TFFReachabilityNotification alloc] init];
    
    __block BOOL notificationReceived = NO;
    [[NSNotificationCenter defaultCenter] addObserverForName:TFFReachabilityStatusDidChangeNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *notification){
                                                      notificationReceived = YES;
                                                      XCTAssertEqual(notification.object, self.testObject);
                                                      XCTAssertEqualObjects(notification.userInfo[TFFReachabilityNotificationStatus], @(TFFReachabilityStatusReachable));
                                                  }];
 
    [self.testObject startMonitoring];
    
    XCTAssertTrue(notificationReceived);
}

@end

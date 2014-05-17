#import <XCTest/XCTest.h>
#import "TFFReachabilityKVO.h"

static void * reachabilityContext = &reachabilityContext;

@interface TFFReachabilityKVOTests : XCTestCase
@property (nonatomic) TFFReachabilityKVO *testObject;
@property (nonatomic) BOOL valueObserved;
@end

@implementation TFFReachabilityKVOTests

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == reachabilityContext) {
        TFFReachabilityKVO *reachability = object;
        XCTAssertEqual(reachability.reachabilityStatus, TFFReachabilityStatusReachable);
        self.valueObserved = YES;
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)testReachabilityKVO {
    self.testObject = [[TFFReachabilityKVO alloc] init];
    
    [self.testObject addObserver:self
                      forKeyPath:@"reachabilityStatus"
                         options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                         context:&reachabilityContext];
    
    [self.testObject startMonitoring];
    
    XCTAssertTrue(self.valueObserved);
}

@end

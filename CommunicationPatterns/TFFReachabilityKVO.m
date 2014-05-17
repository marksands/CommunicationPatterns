#import "TFFReachabilityKVO.h"

@interface TFFReachabilityKVO ()
@property (readwrite, nonatomic) TFFReachabilityStatus reachabilityStatus;
@end

@implementation TFFReachabilityKVO

- (void)networkStatusChanged:(TFFReachabilityStatus)status {
    self.reachabilityStatus = status;
}

@end

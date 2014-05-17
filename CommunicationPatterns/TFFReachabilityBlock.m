#import "TFFReachabilityBlock.h"

@interface TFFReachabilityBlock ()
@property (nonatomic, copy) void(^reachabilityStatusChangedBlock)(TFFReachabilityStatus status);
@end

@implementation TFFReachabilityBlock

- (void)networkStatusChanged:(TFFReachabilityStatus)status {
    if (_reachabilityStatusChangedBlock) {
        self.reachabilityStatusChangedBlock(status);
    }
}

@end

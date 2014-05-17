#import "TFFReachabilityDelegate.h"

@implementation TFFReachabilityDelegate

- (void)networkStatusChanged:(TFFReachabilityStatus)status {
    [self.delegate networkStatusChanged:status];
}

@end

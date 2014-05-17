#import "TFFReachability.h"

@interface TFFReachabilityBlock : TFFReachability

- (void)setReachabilityStatusChangedBlock:(void(^)(TFFReachabilityStatus status))block;

@end

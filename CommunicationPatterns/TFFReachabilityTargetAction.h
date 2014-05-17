#import "TFFReachability.h"

@interface TFFReachabilityTargetAction : TFFReachability

- (void)addTarget:(id)target action:(SEL)action forStatus:(TFFReachabilityStatus)status;
- (void)removeTarget:(id)target action:(SEL)action forStatus:(TFFReachabilityStatus)status;

@end

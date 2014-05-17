#import <ESCObservable/ESCObservable.h>
#import "TFFReachability.h"

@protocol TFFReachabilityObserver <NSObject>
- (void)networkStatusChanged:(TFFReachabilityStatus)status;
@end

@interface TFFReachabilityESCObservable : TFFReachability <ESCObservable>
@end

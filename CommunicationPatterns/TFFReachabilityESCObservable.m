#import "TFFReachabilityESCObservable.h"

@interface TFFReachabilityESCObservable () <ESCObservableInternal>
@end

@implementation TFFReachabilityESCObservable

- (id)init {
    if (self = [super init]) {
        [self escRegisterObserverProtocol:@protocol(TFFReachabilityObserver)];
    }
    return self;
}

- (void)networkStatusChanged:(TFFReachabilityStatus)status {
    [self.escNotifier networkStatusChanged:status];
}

@end

typedef NS_ENUM(NSInteger, TFFReachabilityStatus) {
    TFFReachabilityStatusNotReachable = 0,
    TFFReachabilityStatusReachable    = 1
};

@interface TFFReachability : NSObject

- (BOOL)isReachable;

- (void)startMonitoring;
- (void)stopMonitoring;

@end

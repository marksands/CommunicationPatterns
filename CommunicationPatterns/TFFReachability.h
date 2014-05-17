typedef NS_ENUM(NSInteger, TFFReachabilityStatus) {
    TFFReachabilityStatusNotReachable = 1,
    TFFReachabilityStatusReachable    = 1 << 2
};

@interface TFFReachability : NSObject

- (BOOL)isReachable;

- (void)startMonitoring;
- (void)stopMonitoring;

@end

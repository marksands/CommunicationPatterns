#import "TFFReachability.h"
#import <SystemConfiguration/SystemConfiguration.h>

#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>

@interface TFFReachability ()
@property (nonatomic) SCNetworkReachabilityRef reachability;
@property (nonatomic) TFFReachabilityStatus status;
- (void)networkStatusChanged:(TFFReachabilityStatus)status;
@end

static TFFReachabilityStatus TFFReachabilityStatusForFlags(SCNetworkReachabilityFlags flags) {
    BOOL isReachable = ((flags & kSCNetworkReachabilityFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkReachabilityFlagsConnectionRequired) != 0);
    BOOL canConnectionAutomatically = (((flags & kSCNetworkReachabilityFlagsConnectionOnDemand) != 0) || ((flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0));
    BOOL canConnectWithoutUserInteraction = (canConnectionAutomatically && (flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0);
    BOOL isNetworkReachable = (isReachable && (!needsConnection || canConnectWithoutUserInteraction));
    
    TFFReachabilityStatus status = TFFReachabilityStatusNotReachable;
    if (isNetworkReachable != NO) {
        status = TFFReachabilityStatusReachable;
    }
    
    return status;
}

static void TFFReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void *info) {
    TFFReachabilityStatus status = TFFReachabilityStatusForFlags(flags);
    TFFReachability *reachability = (__bridge id)info;
    [reachability networkStatusChanged:status];
}

@implementation TFFReachability

- (id)init {
    if (self = [super init]) {
        struct sockaddr_in address;
        memset(&address, 0, sizeof(address));
        address.sin_len = sizeof(address);
        address.sin_family = AF_INET;
        self.reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault,(const struct sockaddr*)&address);
    }
    return self;
}

- (void)dealloc {
    [self stopMonitoring];
    
    if (_reachability) {
        CFRelease(_reachability);
        _reachability = NULL;
    }
}

- (TFFReachabilityStatus)currentNetworkStatus {
    SCNetworkReachabilityFlags flags;
    SCNetworkReachabilityGetFlags(self.reachability, &flags);
    return TFFReachabilityStatusForFlags(flags);
}

#pragma mark -

- (BOOL)isReachable {
    return self.status == TFFReachabilityStatusReachable;
}

- (void)startMonitoring {
    [self stopMonitoring];
    
    SCNetworkReachabilityContext context = {0, (__bridge void *)self, NULL, NULL, NULL};
    if (SCNetworkReachabilitySetCallback(self.reachability, TFFReachabilityCallback, &context)) {
        SCNetworkReachabilityScheduleWithRunLoop(self.reachability, CFRunLoopGetMain(), kCFRunLoopCommonModes);
        [self networkStatusChanged:[self currentNetworkStatus]];
    }
}

- (void)stopMonitoring {
    if (_reachability) {
        SCNetworkReachabilityUnscheduleFromRunLoop(self.reachability, CFRunLoopGetMain(), kCFRunLoopCommonModes);
    }
}

#pragma mark -

- (void)networkStatusChanged:(TFFReachabilityStatus)status {
    NSAssert(NO, @"This is an abstract method and should be overridden");
}

@end

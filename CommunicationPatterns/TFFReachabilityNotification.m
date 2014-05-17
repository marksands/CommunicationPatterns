#import "TFFReachabilityNotification.h"

NSString * const TFFReachabilityStatusDidChangeNotification = @"TFFReachabilityStatusDidChangeNotification";
NSString * const TFFReachabilityNotificationStatus = @"TFFReachabilityNotificationStatus";

@implementation TFFReachabilityNotification

- (void)networkStatusChanged:(TFFReachabilityStatus)status {
    [[NSNotificationCenter defaultCenter] postNotificationName:TFFReachabilityStatusDidChangeNotification
                                                        object:self
                                                      userInfo:@{TFFReachabilityNotificationStatus:@(status)}];
}

@end

#import "TFFReachability.h"

@protocol TFFReachabilityDelegate <NSObject>
- (void)networkStatusChanged:(TFFReachabilityStatus)status;
@end

@interface TFFReachabilityDelegate : TFFReachability

@property (nonatomic, weak) id<TFFReachabilityDelegate> delegate;

@end

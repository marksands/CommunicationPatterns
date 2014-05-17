#import "TFFViewController.h"
#import "TFFReachabilityTargetAction.h"

@interface TFFViewController ()
@property (nonatomic) TFFReachabilityTargetAction *reachability;
@end

@implementation TFFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.reachability = [[TFFReachabilityTargetAction alloc] init];
    [self.reachability startMonitoring];
}

- (void)dealloc {
    [self.reachability stopMonitoring];
}

@end

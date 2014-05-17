#import "TFFDelegationViewController.h"
#import "TFFReachabilityDelegate.h"

@interface TFFDelegationViewController () <TFFReachabilityDelegate>
@property (nonatomic) TFFReachabilityDelegate *reachability;
@property (nonatomic, weak) IBOutlet UIView *delegateView;
@end

@implementation TFFDelegationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.reachability = [[TFFReachabilityDelegate alloc] init];
    self.reachability.delegate = self;
}

- (void)dealloc {
    [self.reachability stopMonitoring];
}

- (IBAction)startMonitoring:(id)sender {
    [self.reachability startMonitoring];
}

- (void)networkStatusChanged:(TFFReachabilityStatus)status {
    self.delegateView.layer.borderColor = status == TFFReachabilityStatusReachable ? [UIColor colorWithRed:0 green:0.8 blue:0 alpha:1].CGColor : [UIColor redColor].CGColor;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"borderWidth"];
    animation.repeatCount = 3;
    animation.autoreverses = YES;
    animation.fromValue = @(0);
    animation.toValue = @(12);
    [self.delegateView.layer addAnimation:animation forKey:@"borderWidth"];
}

@end

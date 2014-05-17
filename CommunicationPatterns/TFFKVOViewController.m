#import "TFFKVOViewController.h"
#import "TFFReachabilityKVO.h"

static void * reachabilityObserving = &reachabilityObserving;

@interface TFFKVOViewController ()
@property (nonatomic, weak) IBOutlet UIView *observingView;
@property (nonatomic) TFFReachabilityKVO *reachability;
@end

@implementation TFFKVOViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.reachability = [[TFFReachabilityKVO alloc] init];
    
    [self.reachability addObserver:self
                        forKeyPath:@"reachabilityStatus"
                           options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew
                           context:reachabilityObserving];
}

- (void)dealloc {
    [self.reachability stopMonitoring];
}

- (IBAction)startMonitoring:(id)sender {
    [self.reachability startMonitoring];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == reachabilityObserving) {
        TFFReachabilityKVO *reachability = object;
        [self observedReachabilityStatus:reachability.reachabilityStatus];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)observedReachabilityStatus:(TFFReachabilityStatus)status {
    self.observingView.layer.borderColor = status == TFFReachabilityStatusReachable ? [UIColor colorWithRed:0 green:0.8 blue:0 alpha:1].CGColor : [UIColor redColor].CGColor;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"borderWidth"];
    animation.repeatCount = 3;
    animation.autoreverses = YES;
    animation.fromValue = @(0);
    animation.toValue = @(12);
    [self.observingView.layer addAnimation:animation forKey:@"borderWidth"];
}

@end

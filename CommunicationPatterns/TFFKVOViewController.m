#import "TFFKVOViewController.h"
#import "TFFReachabilityKVO.h"

static void * reachabilityObserving = &reachabilityObserving;

@interface KVOListener : UIView
@end

@implementation KVOListener

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == reachabilityObserving) {
        TFFReachabilityKVO *reachability = object;
        [self observedReachabilityStatus:reachability.reachabilityStatus];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)observedReachabilityStatus:(TFFReachabilityStatus)status {
    self.layer.borderColor = status == TFFReachabilityStatusReachable ? [UIColor colorWithRed:0 green:0.8 blue:0 alpha:1].CGColor : [UIColor redColor].CGColor;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"borderWidth"];
    animation.repeatCount = 3;
    animation.autoreverses = YES;
    animation.fromValue = @(0);
    animation.toValue = @(6);
    [self.layer addAnimation:animation forKey:@"borderWidth"];
}

@end

#pragma mark -

@interface TFFKVOViewController ()
@property (nonatomic, weak) IBOutlet KVOListener *observingView1;
@property (nonatomic, weak) IBOutlet KVOListener *observingView2;
@property (nonatomic, weak) IBOutlet KVOListener *observingView3;
@property (nonatomic) TFFReachabilityKVO *reachability;
@end

@implementation TFFKVOViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.reachability = [[TFFReachabilityKVO alloc] init];
    
    [self.reachability addObserver:self.observingView1
                        forKeyPath:@"reachabilityStatus"
                           options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew
                           context:reachabilityObserving];
    [self.reachability addObserver:self.observingView2
                        forKeyPath:@"reachabilityStatus"
                           options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew
                           context:reachabilityObserving];
    [self.reachability addObserver:self.observingView3
                        forKeyPath:@"reachabilityStatus"
                           options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew
                           context:reachabilityObserving];
}

- (void)dealloc {
    [self.reachability removeObserver:self.observingView1 forKeyPath:@"reachabilityStatus"];
    [self.reachability removeObserver:self.observingView2 forKeyPath:@"reachabilityStatus"];
    [self.reachability removeObserver:self.observingView3 forKeyPath:@"reachabilityStatus"];
    [self.reachability stopMonitoring];
}

- (IBAction)startMonitoring:(id)sender {
    [self.reachability startMonitoring];
}

@end

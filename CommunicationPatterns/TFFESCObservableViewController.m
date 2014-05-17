#import "TFFESCObservableViewController.h"
#import "TFFReachabilityESCObservable.h"

@interface ESCListener : UIView <TFFReachabilityObserver>
@end

@implementation ESCListener
- (void)networkStatusChanged:(TFFReachabilityStatus)status {
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

@interface TFFESCObservableViewController ()
@property (nonatomic, weak) IBOutlet ESCListener *listener1;
@property (nonatomic, weak) IBOutlet ESCListener *listener2;
@property (nonatomic, weak) IBOutlet ESCListener *listener3;
@property (nonatomic) TFFReachabilityESCObservable *reachability;
@end

@implementation TFFESCObservableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.reachability = [[TFFReachabilityESCObservable alloc] init];
    
    [self.reachability escAddObserver:self.listener1];
    [self.reachability escAddObserver:self.listener2];
    [self.reachability escAddObserver:self.listener3];
}

- (IBAction)startMonitoring:(id)sender {
    [self.reachability startMonitoring];
}

@end

#import "TFFTargetActionViewController.h"
#import "TFFReachabilityTargetAction.h"

#pragma mark - Target

@implementation TargetListeningForReachable
- (void)reachabilityBecameReachable {
    self.layer.borderColor = [UIColor colorWithRed:0 green:0.8 blue:0 alpha:1].CGColor;

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"borderWidth"];
    animation.repeatCount = 3;
    animation.autoreverses = YES;
    animation.fromValue = @(0);
    animation.toValue = @(6);
    [self.layer addAnimation:animation forKey:@"borderWidth"];
}
@end

@implementation TargetListeningForNotReachable
- (void)reachabilityBecameNotReachable {
    self.layer.borderColor = [UIColor redColor].CGColor;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"borderWidth"];
    animation.repeatCount = 3;
    animation.autoreverses = YES;
    animation.fromValue = @(0);
    animation.toValue = @(6);
    [self.layer addAnimation:animation forKey:@"borderWidth"];
}
@end

@implementation TargetListeningForAnyReachable
- (void)reachabilityStatusChanged:(TFFReachabilityStatus)status {
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

@interface TFFTargetActionViewController ()
@property (nonatomic, weak) IBOutlet TargetListeningForReachable *targetForReachable;
@property (nonatomic, weak) IBOutlet TargetListeningForNotReachable *targetForNotReachable;
@property (nonatomic, weak) IBOutlet TargetListeningForAnyReachable *targetForAnyReachable;
@property (nonatomic) TFFReachabilityTargetAction *reachability;
@end

@implementation TFFTargetActionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.reachability = [[TFFReachabilityTargetAction alloc] init];
    
    [self.reachability addTarget:self.targetForReachable
                          action:@selector(reachabilityBecameReachable)
                       forStatus:TFFReachabilityStatusReachable];
    
    [self.reachability addTarget:self.targetForNotReachable
                          action:@selector(reachabilityBecameNotReachable)
                       forStatus:TFFReachabilityStatusNotReachable];
    
    [self.reachability addTarget:self.targetForAnyReachable
                          action:@selector(reachabilityStatusChanged:)
                       forStatus:TFFReachabilityStatusNotReachable|TFFReachabilityStatusReachable];
}

- (void)dealloc {
    [self.reachability removeTarget:self.targetForReachable
                             action:@selector(reachabilityBecameReachable)
                          forStatus:TFFReachabilityStatusReachable];
    
    [self.reachability removeTarget:self.targetForNotReachable
                             action:@selector(reachabilityBecameNotReachable)
                          forStatus:TFFReachabilityStatusNotReachable];
    
    [self.reachability removeTarget:self.targetForAnyReachable
                             action:@selector(reachabilityStatusChanged:)
                          forStatus:TFFReachabilityStatusNotReachable|TFFReachabilityStatusReachable];

    [self.reachability stopMonitoring];
}

- (IBAction)startMonitoring:(id)sender {
    [self.reachability startMonitoring];
}

@end

#import "TFFNotificationCenterViewController.h"
#import "TFFReachabilityNotification.h"

@interface NotificationListener : UIView
@end

@implementation NotificationListener
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(networkStatusChanged:)
                                                     name:TFFReachabilityStatusDidChangeNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)networkStatusChanged:(NSNotification *)notification {
    TFFReachabilityStatus status = [notification.userInfo[TFFReachabilityNotificationStatus] integerValue];

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

@interface TFFNotificationCenterViewController ()
@property (nonatomic, weak) IBOutlet NotificationListener *listener1;
@property (nonatomic, weak) IBOutlet NotificationListener *listener2;
@property (nonatomic, weak) IBOutlet NotificationListener *listener3;
@property (nonatomic) TFFReachabilityNotification *reachability;
@end

@implementation TFFNotificationCenterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.reachability = [[TFFReachabilityNotification alloc] init];
}

- (IBAction)startMonitoring:(id)sender {
    [self.reachability startMonitoring];
}

@end

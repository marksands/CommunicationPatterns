#import "TFFBlocksViewController.h"
#import "TFFReachabilityBlock.h"

@interface ArcView : UIView
- (void)drawArc:(UIColor *)color;
@end

@interface TFFBlocksViewController ()
@property (nonatomic, weak) IBOutlet UILabel *reachabilityLabel;
@property (nonatomic, weak) IBOutlet UILabel *callbackLabel;
@property (nonatomic, weak) IBOutlet ArcView *arcView;
@property (nonatomic) TFFReachabilityBlock *reachability;
@end

@implementation TFFBlocksViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.reachability = [[TFFReachabilityBlock alloc] init];
    
    __weak typeof(self) weakSelf = self;
    [self.reachability setReachabilityStatusChangedBlock:^(TFFReachabilityStatus status){
        typeof(weakSelf) strongSelf = weakSelf;
        if (status == TFFReachabilityStatusReachable) {
            [strongSelf animateArc:[UIColor colorWithRed:0 green:0.8 blue:0 alpha:1]];
        } else {
            [strongSelf animateArc:[UIColor redColor]];
        }
    }];
}

- (void)dealloc {
    [self.reachability stopMonitoring];
}

- (IBAction)startMonitoring:(id)sender {
    [self.reachability startMonitoring];
}

- (void)animateArc:(UIColor *)color {
    [self.arcView drawArc:color];
}

@end

#pragma mark - 

@interface ArcView ()
@property (nonatomic) UIColor *color;
@property (nonatomic) CAShapeLayer *circleLayer;
@property (nonatomic) CGPathRef path;
@end

@implementation ArcView

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        self.path = CGPathRetain([UIBezierPath bezierPathWithArcCenter:center
                                                                radius:self.bounds.size.width / 2
                                                            startAngle:-M_PI_2
                                                              endAngle:2*M_PI - M_PI_2
                                                             clockwise:YES].CGPath);
    }
    return self;
}

- (void)dealloc {
    CGPathRelease(_path);
}

- (CGFloat)_circumference {
    return 2 * M_PI * self.bounds.size.width/2;
}

- (void)drawArc:(UIColor *)color {
    self.color = color;

    _circleLayer = [CAShapeLayer layer];
    _circleLayer.path = self.path;
    _circleLayer.fillColor = nil;
    _circleLayer.strokeColor = self.color.CGColor;
    _circleLayer.lineWidth = 3;
    _circleLayer.lineDashPattern = @[@([self _circumference]/4.0), @(3*[self _circumference]/4.0)];
    [self.layer addSublayer:self.circleLayer];
    
    [self stopAnimating];
    [self startAnimating];
    [self setNeedsDisplay];
}

#pragma mark -

- (void)startAnimating {
    CABasicAnimation *theAnimation;
    
    theAnimation = [CABasicAnimation animationWithKeyPath:@"lineDashPhase"];
    theAnimation.fromValue = @(0);
    theAnimation.toValue = @([self _circumference]);
    theAnimation.duration = 1.5f;
    theAnimation.delegate = self;
    [_circleLayer addAnimation:theAnimation forKey:@"stroke"];
}

- (void)stopAnimating {
    [_circleLayer removeAnimationForKey:@"stroke"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self stopAnimating];
    
    [self.circleLayer removeFromSuperlayer];
    self.circleLayer = nil;
}

#pragma mark -

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, self.color.CGColor);
    CGContextSetStrokeColorWithColor(ctx, self.color.CGColor);
}

@end

#import "TFFReachabilityTargetAction.h"
#import <objc/message.h>

@interface TFFReachabilityStatusControl : NSObject
@property (nonatomic, weak) id target;
@property (nonatomic) SEL action;
@property (nonatomic) TFFReachabilityStatus status;
+ (instancetype)controlWithTarget:(id)target action:(SEL)action forStatus:(TFFReachabilityStatus)status;
@end

@implementation TFFReachabilityStatusControl
+ (instancetype)controlWithTarget:(id)target action:(SEL)action forStatus:(TFFReachabilityStatus)status {
    TFFReachabilityStatusControl *control = [[TFFReachabilityStatusControl alloc] init];
    control.target = target;
    control.action = action;
    control.status = status;
    return control;
}
@end

#pragma mark - 

@interface TFFReachabilityTargetAction ()
@property (nonatomic) NSMutableArray *registeredControls;
@end

@implementation TFFReachabilityTargetAction

- (id)init {
    if (self = [super init]) {
        self.registeredControls = [NSMutableArray array];
    }
    return self;
}

- (void)addTarget:(id)target action:(SEL)action forStatus:(TFFReachabilityStatus)status {
    [self.registeredControls addObject:[TFFReachabilityStatusControl controlWithTarget:target action:action forStatus:status]];
}

- (void)removeTarget:(id)target action:(SEL)action forStatus:(TFFReachabilityStatus)status {
    NSMutableArray *discard = [[NSMutableArray alloc] init];
    
    for (TFFReachabilityStatusControl *control in self.registeredControls) {
        if (control.target == target && control.action == action && control.status == status) {
            [discard addObject:control];
        }
    }
    
    [self.registeredControls removeObjectsInArray:discard];
}

- (void)networkStatusChanged:(TFFReachabilityStatus)status {
    for (TFFReachabilityStatusControl *control in self.registeredControls) {
        if (control.status & status) {
            objc_msgSend(control.target, control.action, status);
        }
    }
}

@end

#import "DashedView.h"

@implementation DashedView

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
    CGFloat dashes[] = {8,8};
    CGContextSetLineDash(context, 0.0, dashes, 2);
    CGContextSetLineWidth(context, 1);
    CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGContextStrokePath(context);
}

@end

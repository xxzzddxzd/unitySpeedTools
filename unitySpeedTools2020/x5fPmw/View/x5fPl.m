#import "x5fPl.h"

@implementation x5fPl

@synthesize lineColor = _lineColor;
@synthesize closedType = _closedType;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.opaque = NO;
        self.closedType = x5fPlctt;
        self.width = 1;
    }
    return self;
}

- (void)dealloc
{
    self.lineColor = nil;
    
    [super dealloc];
}

- (UIColor *)lineColor
{
    if (_lineColor == nil) {
        self.lineColor = XX_LINE_DEFAULT_COLOR;
    }
    return _lineColor;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    // context init
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    CGContextSetLineWidth(context, self.width);
    // add points
    CGFloat x = (_closedType == x5fPlctr) ? 1 : 0;
    CGFloat y = (_closedType == x5fPlctb) ? 1 : 0;
    CGContextMoveToPoint(context, x, y);
    if (_closedType == x5fPlctt || _closedType == x5fPlctb) {
        x = self.frame.size.width;
    } else {
        y = self.frame.size.height;
    }
    CGContextAddLineToPoint(context, x, y);
    // context finish
    CGContextStrokePath(context);
}

@end

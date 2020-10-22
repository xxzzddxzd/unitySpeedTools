#import "x5fPb.h"
@interface x5fPb ()
@property(nonatomic,retain) UIColor *normalBackgroundColor;
// background color for normal state
// 备份用，在找不到state相应的backgroundColor时使用normal background color
@end

@implementation x5fPb
+ (id)buttonWithType:(x5fPbt)style {
    x5fPb* button = [super buttonWithType:UIButtonTypeCustom];
    
    switch (style) {
        case x5fPbsc:
        { // 自定义风格，求别搞
        }
            break;
    }
    
    return button;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    self.normalBackgroundColor = nil;
    [_backgroundColorForStates release];
    _backgroundColorForStates = nil;
    
    [super dealloc];
}

#pragma mark -

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    // code for -[XXButton setBackgroundColor:forState:]
    [self refreshBackgroundColorForCurrentState];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    // code for -[XXButton setBackgroundColor:forState:]
    [self refreshBackgroundColorForCurrentState];

}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    // code for -[XXButton setBackgroundColor:forState:]
    [self refreshBackgroundColorForCurrentState];
    // line / border
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    // code for -[XXButton setBackgroundColor:forState:]
    // 非 -[XXButton setBackgroundColor:forState:] 相关方法调用，作为normal保存起来
    // 以便找不到backgroundColorForStates时恢复normal颜色
    self.normalBackgroundColor = backgroundColor;
}


#pragma mark - methods for -[x5fPb setBackgroundColor:forState:]

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state
{
    if (_backgroundColorForStates == nil) {
        _backgroundColorForStates = [[NSMutableDictionary alloc] init];
    }
    
    if (color) {
        [_backgroundColorForStates setObject:color forKey:@(state)];
    } else {
        [_backgroundColorForStates removeObjectForKey:@(state)];
    }
    // normal state
    if (state == UIControlStateNormal) {
        self.normalBackgroundColor = color;
    }
    // 如果与当前状态一致，立即更改
    if (self.state == state) {
        super.backgroundColor = color ? color : self.normalBackgroundColor; // super set background color
    }
}

- (void)refreshBackgroundColorForCurrentState
{
    if (_backgroundColorForStates) {
        UIColor *color = [_backgroundColorForStates objectForKey:@(self.state)];
        if (color) {
            // 找到相关backgroundColor
            super.backgroundColor = color; // super set background color
        } else {
            // 找不到
            super.backgroundColor = self.normalBackgroundColor;
        }
    }
}

@end

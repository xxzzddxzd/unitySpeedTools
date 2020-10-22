#import "x5fPav.h"
#import "x5fPavm.h"
#import "x5fPl.h"
#import <QuartzCore/QuartzCore.h>
#import "x5fPb.h"

#define kAlertViewAutoDismissButtonIndex    -999

#define kAlertViewDismissAnimationSymbol    @"AlertViewDismissAnimation"
#define kAlertViewAnimationTypeKey          @"AlertViewAnimationTypeKey"
#define kAlertViewAnimationButtonIndexKey   @"AlertViewAnimationButtonIndexKey"

#pragma mark - x5fPav (Animations)
#pragma mark -

@interface x5vc : UIViewController

@end
@implementation x5vc

- (BOOL)prefersStatusBarHidden
{
//    NSLog(@"********HIDDEN x5vc*********");
    return YES; //返回NO表示要显示，返回YES将hiden
}
@end

@implementation x5fPav (Animations)

// 灰色背景淡入
+ (CAAnimation *)animationForShowingDimWindow
{
    CABasicAnimation *backgroundAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    backgroundAnimation.duration = 0.2;
    backgroundAnimation.removedOnCompletion = YES;
    backgroundAnimation.fromValue = (id)[UIColor colorWithWhite:0 alpha:0.0f].CGColor;
    backgroundAnimation.toValue = (id)[UIColor colorWithWhite:0 alpha:0.3f].CGColor;
    backgroundAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    return backgroundAnimation;
}

// alertView弹出动画
+ (CAAnimation *)animationForShowingAlertView
{
    CGFloat duration = 0.3;
    // 淡入
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.removedOnCompletion = YES;
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.duration = duration;
    opacityAnimation.values = @[ @(0.0), @(1.0) ];
    opacityAnimation.keyTimes = @[ @(0.0), @(0.9) ];
    opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    // 放大缩小
    CAKeyframeAnimation *popupAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popupAnimation.removedOnCompletion = YES;
    popupAnimation.fillMode = kCAFillModeForwards;
    popupAnimation.duration = duration;
    popupAnimation.values = @[ [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.19, 1.19, 1.19)],
                               [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.2)],
                               [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)] ];
    popupAnimation.keyTimes = @[ @(0.0), @(0.15), @(0.9) ];
    popupAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    // 动画组合
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    animation.removedOnCompletion = YES;
    animation.animations = @[ opacityAnimation, popupAnimation ];
    animation.duration = duration;
    animation.removedOnCompletion = YES;
    
    return animation;
}

// 灰色背景淡出
+ (CAAnimation *)animationForDismissingDimWindow
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.duration = 0.15;
    animation.fromValue = [NSNumber numberWithFloat:1.0];
    animation.toValue = [NSNumber numberWithFloat:0.0];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return animation;
}

// alertView消失动画
+ (CAAnimation *)animationForDismissingAlertView
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.duration = 0.2;
    animation.fromValue = [NSNumber numberWithFloat:1];
    animation.toValue = [NSNumber numberWithFloat:0.8];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return animation;
}

@end

#pragma mark - x5fPav
#pragma mark -

@interface x5fPav () {
    BOOL _dismissed; // 是否已经消失，避免两次调用dismiss导致crash
}
@property(nonatomic,retain) UIWindow *dimWindow;
@property(nonatomic,retain) NSMutableArray *buttonArray;
@end

@implementation x5fPav

@synthesize delegate = _delegate;
@synthesize autoDismissWhenEnteringBackground = _autoDismissWhenEnteringBackground;

@synthesize title = _title;
@synthesize message = _message;

@synthesize cancelButtonIndex = _cancelButtonIndex;
@synthesize firstOtherButtonIndex = _firstOtherButtonIndex;

@synthesize dimWindow = _dimWindow;
@synthesize titleLabel = _titleLabel;
@synthesize messageLabel = _messageLabel;
@synthesize buttonArray = _buttonArray;

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        self.backgroundColor = kAlertViewBackgroundColor;
        self.layer.cornerRadius = 6;
        self.clipsToBounds = YES;
        self.delegate = delegate;
        self.title = title;
        self.message = message;
        _cancelButtonIndex = -1;
        _firstOtherButtonIndex = -1;
        _clickedButtonIndex = -1;
        NSMutableArray *buttonArray = [[NSMutableArray alloc] init];
        self.buttonArray = buttonArray;
        [buttonArray release];
        
        [self loadDimWindow];
        [self loadMainView];
        [self loadTitleLabel:title];
        [self loadMessageLabel:message];
        
        if (cancelButtonTitle != nil) {
            _cancelButtonIndex = [self addButtonWithTitle:cancelButtonTitle];
        }
        va_list args;
        va_start(args, otherButtonTitles);
        for (NSString *otherButtonTitle = otherButtonTitles; otherButtonTitle != nil; otherButtonTitle = va_arg(args, NSString*)) {
            NSInteger buttonIndex = [self addButtonWithTitle:otherButtonTitle];
            if (_firstOtherButtonIndex == -1) {
                _firstOtherButtonIndex = buttonIndex;
            }
        }
        va_end(args);
        [self layoutButtons];
        
        [self layoutMainView];
    }
    
    return self;
}

- (void)dealloc
{
    self.delegate = nil;
    
    self.title = nil;
    self.message = nil;
    
    self.dimWindow = nil;
    self.titleLabel = nil;
    self.messageLabel = nil;
    self.buttonArray = nil;
    [super dealloc];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

#pragma mark - load views methods

- (void)loadDimWindow
{
    if (self.dimWindow == nil) {
        x5vc *temp = [[x5vc alloc] init];
        
//        UIView *tempBGView = [[UIView alloc] initWithFrame:temp.view.frame];
//        tempBGView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        tempBGView.backgroundColor = [UIColor lightGrayColor];
//        [temp.view addSubview:tempBGView];
        temp.view.backgroundColor = [UIColor clearColor];
//        [tempBGView addSubview:self];
        [temp.view addSubview:self];
        
        UIWindow *dimWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        dimWindow.windowLevel = UIWindowLevelAlert - 10;
        dimWindow.userInteractionEnabled = NO;
        dimWindow.rootViewController = temp;
        dimWindow.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3f];
        self.dimWindow = dimWindow;
        [dimWindow release];
    }
}

- (NSInteger)addButtonWithTitle:(NSString *)title
{
    x5fPb *button = [x5fPb buttonWithType:x5fPbsc];
    button.exclusiveTouch = YES;
    button.titleLabel.font = [UIFont systemFontOfSize:kAlertViewButtonFontSize];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:kAlertViewButtonTitleColorNormal forState:UIControlStateNormal];
    [button setBackgroundColor:kAlertViewButtonColorNormal forState:UIControlStateNormal];
    [button setBackgroundColor:kAlertViewButtonColorHighlighted forState:UIControlStateHighlighted];
    button.tag = [self.buttonArray count];
    button.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonArray addObject:button];
    [self addSubview:button];
    return button.tag;
}

- (void)loadMainView
{
    CGRect frame = CGRectMake((CGRectGetWidth(self.dimWindow.frame)-kAlertViewWidth)/2, (CGRectGetHeight(self.dimWindow.frame)-kAlertViewMinHeight)/2, kAlertViewWidth, kAlertViewMinHeight);
    self.frame = frame;
}

- (void)loadTitleLabel:(NSString *)title
{
    if (title == nil || [title length] == 0) {
        return;
    }
    
    CGFloat width = kAlertViewWidth - kAlertViewHorizontalPadding * 2;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kAlertViewHorizontalPadding, kAlertViewTopPadding, width, kAlertViewTitleLabelHeight)];
    titleLabel.clipsToBounds = NO;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.textColor = kAlertViewTitleTextColor;
    titleLabel.font = [UIFont boldSystemFontOfSize:kAlertViewTitleFontSize];
    titleLabel.text = title;
    self.titleLabel = titleLabel;
    [titleLabel release];
    [self addSubview:self.titleLabel];
}

- (void)loadMessageLabel:(NSString *)message
{
    if (message == nil || [message length] == 0) {
        return;
    }
    
    CGFloat width = kAlertViewWidth - kAlertViewHorizontalPadding * 2;
    CGFloat y = kAlertViewTopPadding;
    if (_titleLabel) {
        y += (CGRectGetHeight(_titleLabel.frame) + kAlertViewMiddleSpacing);
    }
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(kAlertViewHorizontalPadding, y, width, 0)];
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = UITextAlignmentCenter;
    messageLabel.textColor = kAlertViewMessageTextColor;
    messageLabel.font = [UIFont systemFontOfSize:kAlertViewMessageFontSize];
    messageLabel.text = message;
    [messageLabel sizeToFit];
    
    if (CGRectGetWidth(messageLabel.frame) < width) {
        CGRect frame = messageLabel.frame;
        frame.size.width = width;
        messageLabel.frame = frame;
    }
    
    if (CGRectGetHeight(messageLabel.frame) > 300) {
        CGRect frame = messageLabel.frame;
        frame.size.height = 300;
        messageLabel.frame = frame;
    }
    self.messageLabel = messageLabel;
    [messageLabel release];
    [self addSubview:self.messageLabel];
}

- (void)addSeparatorLineOnButton:(UIButton *)button extensional:(BOOL)extensional
{
    // 顶部线
    x5fPl *topSeparatorLine = [[x5fPl alloc] initWithFrame:CGRectMake(0, 0, button.frame.size.width, 1)];
    topSeparatorLine.closedType = x5fPlctt;
    topSeparatorLine.lineColor = kAlertViewButtonSeparatorLineColor;
    topSeparatorLine.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    [button addSubview:topSeparatorLine];
    [topSeparatorLine release];
    
    if (extensional) {
        // 两个按钮时的中线
        x5fPl *middleSeparatorLine = [[x5fPl alloc] initWithFrame:CGRectMake(0, 0, 1, button.frame.size.height)];
        middleSeparatorLine.closedType = x5fPlctl;
        middleSeparatorLine.lineColor = kAlertViewButtonSeparatorLineColor;
        middleSeparatorLine.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
        [button addSubview:middleSeparatorLine];
        [middleSeparatorLine release];
    }
}

- (void)layoutButtons
{
    NSUInteger numberOfButtons = self.numberOfButtons;
    CGFloat buttonWidth = 0;
    CGFloat buttonY = 0;
    if (numberOfButtons == 1) { // 一个按钮
        UIButton *button = [_buttonArray objectAtIndex:0];
        buttonWidth = kAlertViewWidth;
        buttonY = self.frame.size.height - kAlertViewButtonHeight;
        button.frame = CGRectMake(0, buttonY, buttonWidth, kAlertViewButtonHeight);
        button.titleLabel.font = [UIFont boldSystemFontOfSize:kAlertViewButtonFontSize]; // 一个按钮一定加粗
        // separator line
        [self addSeparatorLineOnButton:button extensional:NO];
    } else if (numberOfButtons == 2) { // 两个按钮，并排分布
        buttonWidth = kAlertViewWidth / 2;
        buttonY = self.frame.size.height - kAlertViewButtonHeight;
        CGFloat buttonX = 0;
        for (UIButton *button in _buttonArray) {
            button.frame = CGRectMake(buttonX, buttonY, buttonWidth, kAlertViewButtonHeight);
            if (buttonX == 0) { // 两个按钮，右边的按钮加粗
                button.titleLabel.font = [UIFont systemFontOfSize:kAlertViewButtonFontSize];
            } else {
                button.titleLabel.font = [UIFont boldSystemFontOfSize:kAlertViewButtonFontSize];
            }
            // separator line
            [self addSeparatorLineOnButton:button extensional:(buttonX != 0)];
            
            buttonX += buttonWidth;
        }
    } else if (numberOfButtons >= 3) { // 等于或大于三个按钮，垂直分布
        buttonWidth = kAlertViewWidth;
        buttonY = self.frame.size.height - kAlertViewButtonHeight;
        CGRect buttonFrame = CGRectMake(0, buttonY, buttonWidth, kAlertViewButtonHeight);
        UIButton *button = nil;
        BOOL setBold = NO; // 是否已设置一个按钮为加粗，三个按钮以上，最底的按钮加粗
        if (self.cancelButtonIndex != -1) {
            button = [_buttonArray objectAtIndex:self.cancelButtonIndex];
            button.frame = buttonFrame;
            // 三个按钮以上，最底的按钮加粗
            button.titleLabel.font = [UIFont boldSystemFontOfSize:kAlertViewButtonFontSize];
            setBold = YES;
            // separator line
            [self addSeparatorLineOnButton:button extensional:NO];
            
            buttonFrame.origin.y -= kAlertViewButtonHeight;
        }
        // 其他按钮，从最下面的按钮往上遍历
        for (NSInteger i = numberOfButtons - 1; i >= _firstOtherButtonIndex; i--) {
            button = [_buttonArray objectAtIndex:i];
            button.frame = buttonFrame;
            // 三个按钮以上，最底的按钮加粗
            if (setBold == NO) {
                button.titleLabel.font = [UIFont boldSystemFontOfSize:kAlertViewButtonFontSize];
                setBold = YES;
            } else {
                button.titleLabel.font = [UIFont systemFontOfSize:kAlertViewButtonFontSize];
            }
            // separator line
            [self addSeparatorLineOnButton:button extensional:NO];
            
            buttonFrame.origin.y -= kAlertViewButtonHeight;
        }
    }
}

- (void)layoutMainView
{
    CGFloat mainViewHeight = kAlertViewTopPadding;
    // title
    if (_titleLabel != nil) {
        mainViewHeight += _titleLabel.frame.size.height;
        mainViewHeight += kAlertViewMiddleSpacing;
    }
    // message
    if (_messageLabel != nil) {
        mainViewHeight += _messageLabel.frame.size.height;
    } else {
        mainViewHeight -= kAlertViewMiddleSpacing;
    }
    mainViewHeight += kAlertViewBottomPadding;
    // buttons
    NSUInteger numberOfButtons = self.numberOfButtons;
    if (numberOfButtons >= 3) { // 等于大于3个按钮
        UIButton *topButton = (_cancelButtonIndex == -1) ? [_buttonArray objectAtIndex:0] : [_buttonArray objectAtIndex:1];
        mainViewHeight += CGRectGetHeight(self.frame) - CGRectGetMinY(topButton.frame);
    } else if (numberOfButtons > 0) { // 1-2个按钮
        mainViewHeight += kAlertViewButtonHeight;
    } else { // 没有按钮
        
    }
    CGRect frame = self.frame;
    frame.size.height = mainViewHeight;
    frame.origin.y = (CGRectGetHeight(self.dimWindow.frame) - mainViewHeight) / 2;
    self.frame = CGRectIntegral(frame);
    
}

#pragma mark - public methods

- (NSUInteger)numberOfButtons
{
    return [self.buttonArray count];
}

- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex >= 0 && buttonIndex < [_buttonArray count]) {
        UIButton *button = [_buttonArray objectAtIndex:buttonIndex];
        return [button titleForState:UIControlStateNormal];
    } else {
        return nil;
    }
}

- (UIButton *)buttonAtIndex:(NSInteger)buttonIndex
{
    UIButton *button = nil;
    for (UIButton *elem in self.buttonArray) {
        if (elem.tag == buttonIndex) {
            button = elem;
            break;
        }
    }
    return button;
}

- (void)show
{
    [[x5fPavm shareAlertViewManager] showAlertView:self];
}

- (void)showImmediately
{
    if ([[[UIApplication sharedApplication] delegate] respondsToSelector:@selector(window)]){
        UIWindow *window = [[[UIApplication sharedApplication] delegate] performSelector:@selector(window)];
        [self cancelEventsForView:window];
    }
    
    self.dimWindow.userInteractionEnabled = YES;
    [self.dimWindow makeKeyAndVisible];
    
    // 背景变灰动画
    CAAnimation *backgroundAnimation = [[self class] animationForShowingDimWindow];
    [self.dimWindow.layer addAnimation:backgroundAnimation forKey:nil];
    
    // 弹框弹下弹下的动画
    if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
        CAAnimation *animation = [[self class] animationForShowingAlertView];
        [self.layer addAnimation:animation forKey:nil];
    }
    
//    [self.dimWindow addSubview:self];
    
    [self activeTextField];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
    // 防止两次dismiss
    if (_dismissed) {
        return;
    } else {
        _dismissed = YES;
    }
    
    [self willDismissWithButtonIndex:buttonIndex];
    
    if (animated) {
        // 动画事务
        [CATransaction begin];
        // 显式动画
        [CATransaction setDisableActions:YES];
        // 背景淡出动画
        self.dimWindow.layer.opacity = 0.1; // 如果是0，就会相当于 .hidden == YES，则不会挡住用户操作
        CAAnimation *backgroundAnimation = [[self class] animationForDismissingDimWindow];
        backgroundAnimation.delegate = self;
        [backgroundAnimation setValue:kAlertViewDismissAnimationSymbol forKey:kAlertViewAnimationTypeKey];
        [backgroundAnimation setValue:@(buttonIndex) forKey:kAlertViewAnimationButtonIndexKey];
        [self.dimWindow.layer addAnimation:backgroundAnimation forKey:nil];
        // 弹框消失动画
        CAAnimation *animation = [[self class] animationForDismissingAlertView];
        [self.layer addAnimation:animation forKey:nil];
        
        [CATransaction commit];
    } else {
        [self didDismissWithButtonIndex:buttonIndex];
    }
    
}

- (void)willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //    [[XXAlertViewManager shareAlertViewManager] alertViewWillDismiss:self];
    
    if ([self.delegate respondsToSelector:@selector(x5fPav:willDismissWithButtonIndex:)]) {
        [self.delegate x5fPav:self willDismissWithButtonIndex:buttonIndex];
    }
}

- (void)didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    self.dimWindow.userInteractionEnabled = NO;
    self.dimWindow = nil;
    
    if ([self.delegate respondsToSelector:@selector(x5fPav:didDismissWithButtonIndex:)]) {
        [self.delegate x5fPav:self didDismissWithButtonIndex:buttonIndex];
    }
    [self removeFromSuperview];
    
    [[x5fPavm shareAlertViewManager] alertViewDidDismiss:self];
}

- (void)setAutoDismissWhenEnteringBackground
{
    self.autoDismissWhenEnteringBackground = YES;
}

- (void)clearDelegateAndDismiss
{
    self.delegate = nil;
    [self dismissWithClickedButtonIndex:kAlertViewAutoDismissButtonIndex animated:NO];
}

#pragma mark - Animation Delegate methods

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSString *animationKey = [anim valueForKey:kAlertViewAnimationTypeKey];
    if ([animationKey isEqualToString:kAlertViewDismissAnimationSymbol]) {
        [self didDismissWithButtonIndex:[[anim valueForKey:kAlertViewAnimationButtonIndexKey] integerValue]];
    }
}

#pragma mark - private methods

- (void)cancelEventsForView:(UIView *)view
{
    NSArray *gestureRecognizers = view.gestureRecognizers;
    if ([gestureRecognizers count] > 0) {
        // 检查手势，有的话需要cancel掉当前的手势，例如UISwitch的subviews的手势
        for (UIGestureRecognizer *gesture in gestureRecognizers) {
            if (gesture.enabled) {
                gesture.enabled = NO;   // cancel
                gesture.enabled = YES;  // restore
            }
        }
    }
    for (UIView *subview in [view subviews]) {
        if ([subview isKindOfClass:[UITextField class]]) {
            //            [(UITextField *)subview resignFirstResponder];
        } else if ([subview isKindOfClass:[UITextView class]]) {
            //            [(UITextView *)subview resignFirstResponder];
        } else if ([subview isKindOfClass:[UIControl class]]) {
            [(UIControl *)subview cancelTrackingWithEvent:nil];
        }
        [self cancelEventsForView:subview];
    }
}

- (void)activeTextField
{
    for (UIView *subview in [self subviews]) {
        if ([subview isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)subview;
            if (textField.enabled && !textField.hidden) {
                [textField becomeFirstResponder];
                break;
            }
        }
    }
}

#pragma mark - buttons events methods

- (void)buttonClicked:(UIButton *)button
{
    self.userInteractionEnabled = NO;
    _clickedButtonIndex = button.tag;
    
    if ([self.delegate respondsToSelector:@selector(x5fPav:clickedButtonAtIndex:)]) {
        [self.delegate x5fPav:self clickedButtonAtIndex:_clickedButtonIndex];
    }
    [self dismissWithClickedButtonIndex:_clickedButtonIndex animated:YES];
}
- (BOOL)prefersStatusBarHidden
{
//    NSLog(@"********HIDDEN av*********");
    return YES; //返回NO表示要显示，返回YES将hiden
}
@end

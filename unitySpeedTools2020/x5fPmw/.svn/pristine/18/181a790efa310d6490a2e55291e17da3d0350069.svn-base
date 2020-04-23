//
//  XXDraggableButton.m
//  HBDraggableButton
//
//  Created by Hubert on 14-2-18.
//  Copyright (c) 2014年 Hubert. All rights reserved.
//

#import "x5fPdb.h"

#define XX_WAITING_KEYWINDOW_AVAILABLE 0.f
#define XX_AUTODOCKING_ANIMATE_DURATION 0.25f
#define XX_DOUBLE_TAP_TIME_INTERVAL 0.36f
#define XX_BUTTON_CLEAR_TIME_INTERVAL 4.0f
#define XX_BUTTON_CLEAR_ANIMATE_DURATION 0.15f

#define XX_POINT_NULL CGPointMake(MAXFLOAT, -MAXFLOAT)


@interface x5fPdb ()

@property (retain, nonatomic) NSTimer *timer;

- (BOOL)isInsideRect:(CGRect)rect;
- (BOOL)isIntersectsRect:(CGRect)rect;
- (BOOL)isCrossedRect:(CGRect)rect;

- (void)removeAllCodeBlocks;

+ (void)removeAllFromView:(id)superView;

+ (void)removeFromView:(id)superView withTag:(NSInteger)tag;
+ (void)removeFromView:(id)superView withTags:(NSArray *)tags;

+ (void)removeAllFromView:(id)view insideRect:(CGRect)rect;
- (void)removeFromSuperviewInsideRect:(CGRect)rect;

+ (void)removeAllFromView:(id)view intersectsRect:(CGRect)rect;
- (void)removeFromSuperviewIntersectsRect:(CGRect)rect;

+ (void)removeAllFromView:(id)view crossedRect:(CGRect)rect;
- (void)removeFromSuperviewCrossedRect:(CGRect)rect;

@end

@implementation x5fPdb

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self defaultSetting];
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        [self defaultSetting];
    }
    return self;
}

- (id)initInView:(id)view WithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        if (view) {
            [view addSubview:self];
        }
//        else {
//            [self performSelector:@selector(addButtonToKeyWindow) withObject:nil afterDelay:XX_WAITING_KEYWINDOW_AVAILABLE];
//        }
        [self defaultSetting];
    }
    return self;
}

- (void)defaultSetting {
//    [self.layer setCornerRadius:self.frame.size.height / 2];
//    [self.layer setBorderColor:[UIColor lightGrayColor].CGColor];
//    [self.layer setBorderWidth:0.5];
//    [self.layer setMasksToBounds:YES];
    
    self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    _draggable = YES;
    _autoDocking = YES;
    _singleTapBeenCanceled = NO;
    
    _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] init];
    [_longPressGestureRecognizer addTarget:self action:@selector(gestureRecognizerHandle:)];
    [_longPressGestureRecognizer setAllowableMovement:0];
    [self addGestureRecognizer:_longPressGestureRecognizer];
    
    [self setDockPoint:XX_POINT_NULL];
    
    [self setLimitedDistance: -1.f];
    

    CGAffineTransform transform;
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) {
        transform = CGAffineTransformMakeRotation(0);
    }
    else if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        transform = CGAffineTransformMakeRotation(180 * M_PI / 180.0);
    }
    else if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
        transform = CGAffineTransformMakeRotation(90 * M_PI / 180.0);
    }
    else if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft) {
        transform = CGAffineTransformMakeRotation(270 * M_PI / 180.0);
    }
    
//    [self setTransform:transform];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(orientationChange:)
//                                                 name:UIApplicationWillChangeStatusBarOrientationNotification
//                                               object:nil];
 
}

- (void)orientationChange:(NSNotification *)notification
{
    int newOrientation = [[notification.userInfo objectForKey:UIApplicationStatusBarOrientationUserInfoKey] integerValue];
    
    CGAffineTransform transform;
    if (newOrientation == UIInterfaceOrientationPortrait) {
        transform = CGAffineTransformMakeRotation(0);
    }
    else if (newOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        transform = CGAffineTransformMakeRotation(180 * M_PI / 180.0);
    }
    else if (newOrientation == UIInterfaceOrientationLandscapeRight) {
        transform = CGAffineTransformMakeRotation(90 * M_PI / 180.0);
    }
    else if (newOrientation == UIInterfaceOrientationLandscapeLeft ){
        transform = CGAffineTransformMakeRotation(270 * M_PI / 180.0);
    }

    [self setTransform:transform];
}

- (void)addButtonToKeyWindow {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

#pragma mark - Timer handle
- (void)hideWithAlpha
{
    [UIView animateWithDuration:XX_BUTTON_CLEAR_ANIMATE_DURATION animations:^{
        self.alpha = 0.5;
    }];
}

- (void)showWithAlpha
{
    if (self.alpha < 1) {
        [UIView animateWithDuration:XX_BUTTON_CLEAR_ANIMATE_DURATION animations:^{
            self.alpha = 1;
        }];
    }
}

- (void)clearTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)startTimer
{
    
}

#pragma mark - Gesture recognizer handle

- (void)gestureRecognizerHandle:(UILongPressGestureRecognizer *)gestureRecognizer {
    switch ([gestureRecognizer state]) {
        case UIGestureRecognizerStateBegan: {
            if (_longPressBlock) {
                _longPressBlock(self);
            }
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - Blocks
#pragma mark Touch Blocks

- (void)setTapBlock:(void (^)(x5fPdb *))tapBlock {
    _tapBlock = tapBlock;
    
    if (_tapBlock) {
        [self addTarget:self action:@selector(buttonTouched) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - Touch

- (void)buttonTouched {
    [self showWithAlpha];
    [self performSelector:@selector(executeButtonTouchedBlock) withObject:nil afterDelay:(_doubleTapBlock ? XX_DOUBLE_TAP_TIME_INTERVAL : 0)];
}

- (void)executeButtonTouchedBlock {
    if (!_singleTapBeenCanceled && _tapBlock && !_isDragging) {
        _tapBlock(self);
        [self clearTimer];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    _isDragging = NO;
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    if (touch.tapCount == 2) {
        if (_doubleTapBlock) {
            _singleTapBeenCanceled = YES;
            _doubleTapBlock(self);
        }
    } else {
        _singleTapBeenCanceled = NO;
    }
    _beginLocation = [[touches anyObject] locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if (_draggable) {
        _isDragging = YES;
        
        UITouch *touch = [touches anyObject];
        /*
         * 原方法可适用各种SIZE的super view
         *
        CGPoint currentLocation = [touch locationInView:self];
        
        float offsetX = currentLocation.x - _beginLocation.x;
        float offsetY = currentLocation.y - _beginLocation.y;
        
        self.center = CGPointMake(self.center.x + offsetX, self.center.y + offsetY);
        */
        self.center = [touch locationInView:self.superview];
        if ([self isdockPointAvailable] && [self isLimitedDistanceAvailable]) {
            [self checkIfExceedingLimitedDistanceThenFixIt];
        } else {
            [self checkIfOutOfBorderThenFixIt];
        }
        
        if (_draggingBlock) {
            _draggingBlock(self);
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded: touches withEvent: event];
    /* 
     * hubert
     * 当滑动完不执行点击事件
     */
    if (_isDragging) {
        _singleTapBeenCanceled = YES;
    }
    if (_isDragging && _dragDoneBlock) {
        _dragDoneBlock(self);
        _singleTapBeenCanceled = YES;
    }
    
    if (_isDragging && _autoDocking) {
        if ( ![self isdockPointAvailable]) {
            [self dockingToBorder];
        } else {
            [self dockingToPoint];
        }
    }
    
    _isDragging = NO;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    _isDragging = NO;
    [super touchesCancelled:touches withEvent:event];
}

- (BOOL)isDragging {
    return _isDragging;
}

#pragma mark - Docking

- (BOOL)isdockPointAvailable {
    return !CGPointEqualToPoint(self.dockPoint, XX_POINT_NULL);
}

- (void)dockingToBorder {
    CGRect superviewFrame = self.superview.frame;
    CGRect frame = self.frame;
    CGFloat middleX = superviewFrame.size.width / 2;
    CGFloat middleY = superviewFrame.size.height / 2;
    CGPoint resultPoint;
    
    CGFloat minX = MIN(CGRectGetMidX(frame), CGRectGetWidth(superviewFrame) - CGRectGetMidX(frame));
    CGFloat minY = MIN(CGRectGetMidY(frame), CGRectGetHeight(superviewFrame) - CGRectGetMidY(frame));

    if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
        if (minY < 80.0) {
            if (minX < minY) {
                if (self.center.x >= middleX) {
                    resultPoint = CGPointMake(superviewFrame.size.width - frame.size.width / 2, self.center.y);
                } else {
                    resultPoint = CGPointMake(frame.size.width / 2, self.center.y);
                }
            } else {
                if (self.center.y >= middleY) {
                    resultPoint = CGPointMake(self.center.x, CGRectGetHeight(superviewFrame) - CGRectGetHeight(frame) / 2);
                } else {
                    resultPoint = CGPointMake(self.center.x, CGRectGetHeight(frame) / 2);
                }
                
            }
        } else {
            if (self.center.x >= middleX) {
                resultPoint = CGPointMake(superviewFrame.size.width - frame.size.width / 2, self.center.y);
            } else {
                resultPoint = CGPointMake(frame.size.width / 2, self.center.y);
            }
        }
    }
    else if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        if (minX < 80.0f) {
            if (minX < minY) {
                if (self.center.x >= middleX) {
                    resultPoint = CGPointMake(superviewFrame.size.width - frame.size.width / 2, self.center.y);
                } else {
                    resultPoint = CGPointMake(frame.size.width / 2, self.center.y);
                }
            } else {
                if (self.center.y >= middleY) {
                    resultPoint = CGPointMake(self.center.x, CGRectGetHeight(superviewFrame) - CGRectGetHeight(frame) / 2);
                } else {
                    resultPoint = CGPointMake(self.center.x, CGRectGetHeight(frame) / 2);
                }
                
            }
        } else {
            if (self.center.y >= middleY) {
                resultPoint = CGPointMake(self.center.x, CGRectGetHeight(superviewFrame) - CGRectGetHeight(frame) / 2);
            } else {
                resultPoint = CGPointMake(self.center.x, CGRectGetHeight(frame) / 2);
            }
        }
    }

    [UIView animateWithDuration:XX_AUTODOCKING_ANIMATE_DURATION animations:^{
        self.center = resultPoint;
        if (_autoDockingBlock) {
            _autoDockingBlock(self);
        }
    } completion:^(BOOL finished) {
        if (_autoDockingDoneBlock) {
            _autoDockingDoneBlock(self);
        }
    }];
    
    
    
}

- (void)dockingToPoint {
    [UIView animateWithDuration:XX_AUTODOCKING_ANIMATE_DURATION animations:^{
        self.center = self.dockPoint;
        if (_autoDockingBlock) {
            _autoDockingBlock(self);
        }
    } completion:^(BOOL finished) {
        if (_autoDockingDoneBlock) {
            _autoDockingDoneBlock(self);
        }
    }];
}

#pragma mark - Dragging

- (BOOL)isLimitedDistanceAvailable {
    return (self.limitedDistance > 0);
}

- (BOOL)checkIfExceedingLimitedDistanceThenFixIt {
    CGPoint tmpDPoint = CGPointMake(self.center.x - self.dockPoint.x, self.center.y - self.dockPoint.y);
    
    CGFloat distance = hypotf(tmpDPoint.x, tmpDPoint.y);
    
    BOOL willExceedingLimitedDistance = distance >= self.limitedDistance;
    
    if (willExceedingLimitedDistance) {
        self.center = CGPointMake(tmpDPoint.x * self.limitedDistance / distance + self.dockPoint.x, tmpDPoint.y * self.limitedDistance / distance + self.dockPoint.y);
    }
    
    return willExceedingLimitedDistance;
}

- (BOOL)checkIfOutOfBorderThenFixIt {
    BOOL willOutOfBorder = NO;
    
    CGRect superviewFrame = self.superview.frame;
    CGRect frame = self.frame;
    CGFloat leftLimitX = frame.size.width / 2;
    CGFloat rightLimitX = superviewFrame.size.width - leftLimitX;
    CGFloat topLimitY = frame.size.height / 2;
    CGFloat bottomLimitY = superviewFrame.size.height - topLimitY;
    
    if (self.center.x > rightLimitX) {
        willOutOfBorder = YES;
        self.center = CGPointMake(rightLimitX, self.center.y);
    }else if (self.center.x <= leftLimitX) {
        willOutOfBorder = YES;
        self.center = CGPointMake(leftLimitX, self.center.y);
    }
    
    if (self.center.y > bottomLimitY) {
        willOutOfBorder = YES;
        self.center = CGPointMake(self.center.x, bottomLimitY);
    }else if (self.center.y <= topLimitY){
        willOutOfBorder = YES;
        self.center = CGPointMake(self.center.x, topLimitY);
    }
    
    return willOutOfBorder;
}

#pragma mark - Common Tools

#pragma mark Items In View

+ (NSArray *)itemsInView:(id)view {
    NSMutableArray *subviews = [NSMutableArray arrayWithArray:[view subviews]];
    
    if (! subviews) {
        subviews = [NSMutableArray arrayWithArray:[[UIApplication sharedApplication].keyWindow subviews]];
    }
    
    for (id view in subviews) {
        if ( ![view isKindOfClass:[x5fPdb class]]) {
            [subviews removeObject:view];
        }
    }
    
    return subviews;
}

- (BOOL)isInView:(id)view {
    return [self.superview isEqual:view];
}

#pragma mark Rect Detecter

- (BOOL)isInsideRect:(CGRect)rect {
    return  CGRectContainsRect(rect, self.frame);
}

- (BOOL)isIntersectsRect:(CGRect)rect {
    return  CGRectIntersectsRect(rect, self.frame);
}

- (BOOL)isCrossedRect:(CGRect)rect {
    return  [self isIntersectsRect:rect] && ![self isInsideRect:rect];
}

#pragma mark Remove All Code Blocks

- (void)removeAllCodeBlocks {
    self.longPressBlock = nil;
    self.tapBlock = nil;
    self.doubleTapBlock = nil;
    
    self.draggingBlock = nil;
    self.dragDoneBlock = nil;
    
    self.autoDockingBlock = nil;
    self.autoDockingDoneBlock = nil;
}

#pragma mark - Remove all from view

+ (void)removeAllFromView:(id)superView {
    for (id view in [self itemsInView:superView]) {
        [view removeFromSuperview];
    }
}

#pragma mark - Remove from view with tag(s)

+ (void)removeFromView:(id)superView withTag:(NSInteger)tag {
    for (id view in [self itemsInView:superView]) {
        if (((x5fPdb *)view).tag == tag) {
            [view removeFromSuperview];
        }
    }
}

+ (void)removeFromView:(id)superView withTags:(NSArray *)tags {
    for (NSNumber *tag in tags) {
        [x5fPdb removeFromView:superView withTag:[tag intValue]];
    }
}

#pragma mark - Remove from view inside rect

+ (void)removeAllFromView:(id)view insideRect:(CGRect)rect {
    for (id subview in [self itemsInView:view]) {
        if ([subview isInsideRect:rect]) {
            [subview removeFromSuperview];
        }
    }
}

- (void)removeFromSuperviewInsideRect:(CGRect)rect {
    if (self.superview && [self isInsideRect:rect]) {
        [self removeFromSuperview];
        [self removeAllCodeBlocks];
    }
}

#pragma mark - Remove From View Overlapped Rect

+ (void)removeAllFromView:(id)view intersectsRect:(CGRect)rect {
    for (id subview in [self itemsInView:view]) {
        if ([subview isIntersectsRect:rect]) {
            [subview removeFromSuperview];
        }
    }
}

- (void)removeFromSuperviewIntersectsRect:(CGRect)rect {
    if (self.superview && [self isIntersectsRect:rect]) {
        [self removeFromSuperview];
    }
}

#pragma mark - Remove From View Crossed Rect

+ (void)removeAllFromView:(id)view crossedRect:(CGRect)rect {
    for (id subview in [self itemsInView:view]) {
        if ([subview isCrossedRect:rect]) {
            [subview removeFromSuperview];
        }
    }
}

- (void)removeFromSuperviewCrossedRect:(CGRect)rect {
    if (self.superview && [self isInsideRect:rect]) {
        [self removeFromSuperview];
    }
}


@end

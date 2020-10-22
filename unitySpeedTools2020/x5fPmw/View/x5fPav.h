#import <UIKit/UIKit.h>
//[UIColor colorWithCGColor:[UIColor redColor].CGColor]
// alertView背景颜色
#define kAlertViewBackgroundColor           [UIColor colorWithWhite:0xe7/255.0 alpha:1]
// 标题颜色
#define kAlertViewTitleTextColor            [UIColor colorWithRed:0x0/255.0f green:0x0/255.0f blue:0x0/255.0f alpha:0.8]
// 内容颜色
#define kAlertViewMessageTextColor          [UIColor colorWithRed:0x0/255.0f green:0x0/255.0f blue:0x0/255.0f alpha:0.8]
// 按钮默认颜色
#define kAlertViewButtonColorNormal         kAlertViewBackgroundColor
// 按钮高亮颜色
#define kAlertViewButtonColorHighlighted    [UIColor colorWithWhite:0xe1/255.0 alpha:1]
// 按钮字体颜色
#define kAlertViewButtonTitleColorNormal    [UIColor colorWithRed:0x15/255.0f green:0x7d/255.0f blue:0xfb/255.0f alpha:1]
// 按钮分割线颜色
#define kAlertViewButtonSeparatorLineColor  [UIColor colorWithRed:0xad/255.0f green:0xae/255.0f blue:0xb0/255.0f alpha:1.0f]


#define kAlertViewTitleFontSize     18.0f           // title字体大小
#define kAlertViewMessageFontSize   16.0f  // message字体大小
#define kAlertViewButtonFontSize    16.0f   // button字体大小

#define kAlertViewWidth             266 // alertView宽度
#define kAlertViewMinHeight         133 // alertView高度

#define kAlertViewHorizontalPadding 20  // alertView水平padding(内边距)
#define kAlertViewTopPadding        20  // alertView顶部padding
#define kAlertViewBottomPadding     22  // alertView底部padding
#define kAlertViewMiddleSpacing     9   // title和message中间的距离

#define kAlertViewTitleLabelHeight  20  // 标题高度
#define kAlertViewButtonHeight      48  // 按钮高度

#define kOffsetYWhenSubViewIsTextField  140.0f

@protocol x5fPavd;  //XXAlertViewDelegate

@interface x5fPav : UIView   //XXAlertView
{
    id/*<XXAlertViewDelegate>*/ _delegate;
    BOOL _autoDismissWhenEnteringBackground;
    
    NSString *_title;
    NSString *_message;
    
    NSInteger _cancelButtonIndex;
    NSInteger _firstOtherButtonIndex;
    NSInteger _clickedButtonIndex;
    
    UIWindow *_dimWindow;
    UILabel *_titleLabel;
    UILabel *_messageLabel;
    NSMutableArray *_buttonArray;
}
@property(nonatomic,assign) id/*<XXAlertViewDelegate>*/ delegate;
@property(nonatomic,assign) BOOL autoDismissWhenEnteringBackground; // 进入后台时是否自动消失，默认为NO

@property(nonatomic,retain) UILabel *titleLabel;    // changed to public
@property(nonatomic,retain) UILabel *messageLabel;  // changed to public
@property(nonatomic,copy)   NSString *title;
@property(nonatomic,copy)   NSString *message;

@property(nonatomic,readonly) NSUInteger numberOfButtons;
@property(nonatomic,readonly) NSInteger cancelButtonIndex;
@property(nonatomic,readonly) NSInteger firstOtherButtonIndex;

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
- (NSUInteger)numberOfButtons;
- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex;
- (UIButton *)buttonAtIndex:(NSInteger)buttonIndex;

- (void)setAutoDismissWhenEnteringBackground;

- (void)show;
- (void)showImmediately;
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;

- (void)clearDelegateAndDismiss;

@end



@interface x5fPav (Animations)
// 灰色背景淡入
+ (CAAnimation *)animationForShowingDimWindow;
// alertView弹出动画
+ (CAAnimation *)animationForShowingAlertView;
// 灰色背景淡出
+ (CAAnimation *)animationForDismissingDimWindow;
// alertView消失动画
+ (CAAnimation *)animationForDismissingAlertView;
@end



@protocol x5fPavd <NSObject>
@optional
- (void)x5fPav:(x5fPav *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)x5fPav:(x5fPav *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex;
- (void)x5fPav:(x5fPav *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;
@end

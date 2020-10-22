#import <UIKit/UIKit.h>

@interface x5fPbvc : UIViewController

@property (nonatomic, retain) UIView *customNavBar;

- (void)initView;
- (void)customNavigationBarLeftItemAction:(UIButton *)button;

- (UIColor *)colorWithHexValue:(NSUInteger)hexValue alpha:(CGFloat)alpha;
- (CGFloat)heightForText:(NSString *)text font:(UIFont *)font constraintWidth:(CGFloat)width;

- (UIImage *)infoButtonBGImage;

@end

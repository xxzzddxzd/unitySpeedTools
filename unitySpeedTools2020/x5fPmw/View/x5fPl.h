#import <UIKit/UIKit.h>

#define XX_LINE_DEFAULT_COLOR  [UIColor colorWithCGColor:[UIColor redColor].CGColor]
//XXLineClosedType
//typedef NS_ENUM(NSInteger, x5fPlct) {
//    XXLineClosedTypeTop = 0,       // 线条靠近顶部
//    XXLineClosedTypeBottom = 1,    // 线条靠近底部
//    XXLineClosedTypeLeft = 2,      // 线条靠近左边
//    XXLineClosedTypeRight = 3      // 线条靠近右边
//};
typedef NS_ENUM(NSInteger, x5fPlct) {
    x5fPlctt = 0,       // 线条靠近顶部
    x5fPlctb = 1,    // 线条靠近底部
    x5fPlctl = 2,      // 线条靠近左边
    x5fPlctr = 3      // 线条靠近右边
};

@interface x5fPl : UIView //XXLine
{
    UIColor *_lineColor;
    x5fPlct _closedType;
}
@property(nonatomic,retain) UIColor *lineColor; // 线条颜色，默认为XX_LINE_DEFAULT_COLOR
@property(nonatomic,assign) x5fPlct closedType; // 默认为XXLineClosedTypeTop
@property(nonatomic,assign) float width; // 默认为XXLineClosedTypeTop

@end

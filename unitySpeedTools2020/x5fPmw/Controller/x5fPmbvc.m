#import "x5fPmbvc.h"
#import "x5fPmgd.h"
#import <QuartzCore/QuartzCore.h>

@interface x5fPbvc ()

@end

@implementation x5fPbvc

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void)initView
{
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [self.navigationController setNavigationBarHidden:YES];
    self.navigationController.view.layer.cornerRadius = 2;
    self.navigationController.view.layer.borderColor = [self colorWithHexValue:0x999999 alpha:1].CGColor;
    self.navigationController.view.layer.borderWidth = 1.0f;
    self.navigationController.view.clipsToBounds = YES;
    
    self.customNavBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kModMainPanelWidth, 41)];
    self.customNavBar.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.customNavBar];
    
    UILabel *title = [[UILabel alloc] initWithFrame:self.customNavBar.frame];
    title.backgroundColor = cColorMainView;
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont boldSystemFontOfSize:18.0f];
    title.text = kTextNavTitle;
    [self.customNavBar addSubview:title];
    
    UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnClose setImage:[self closeButtonBGImage] forState:UIControlStateNormal];
    [btnClose setBackgroundColor:[UIColor clearColor]];
    btnClose.frame = CGRectMake(0, 0, 45, 41);
    [btnClose setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [btnClose setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [btnClose addTarget:self action:@selector(customNavigationBarLeftItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.customNavBar addSubview:btnClose];
}

- (void)dealloc
{
    [self.customNavBar release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customNavigationBarLeftItemAction:(UIButton *)button
{
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            return (UIInterfaceOrientationPortrait == toInterfaceOrientation);
        }
        return (UIInterfaceOrientationPortrait == toInterfaceOrientation) | (UIInterfaceOrientationPortraitUpsideDown == toInterfaceOrientation);
    }
    else {
        return (UIInterfaceOrientationLandscapeLeft == toInterfaceOrientation) | (UIInterfaceOrientationLandscapeRight == toInterfaceOrientation);
    }
    return YES;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            return UIInterfaceOrientationMaskPortrait;
        }
        return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
    }
    else {
        return UIInterfaceOrientationMaskLandscape;
    }
}

#pragma mark - Helper

- (CGFloat)heightForText:(NSString *)text font:(UIFont *)font constraintWidth:(CGFloat)width
{
    CGSize size;
    CGSize constraint = CGSizeMake(width, 10000.0f);

    if ([text respondsToSelector:@selector(sizeWithFont:constrainedToSize:)]) {
        size = [text sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    }
    else {
        NSAttributedString *msgAttributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:font}];
        CGRect rect = [msgAttributedText boundingRectWithSize:constraint
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                         context:nil];
        size = rect.size;
    }
    
    CGFloat height = size.height;

    return height;
}

- (UIColor *)colorWithHexValue:(NSUInteger)hexValue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((hexValue >> 16) & 0x000000FF)/255.0f
                           green:((hexValue >> 8) & 0x000000FF)/255.0f
                            blue:((hexValue) & 0x000000FF)/255.0
                           alpha:alpha];
}

- (UIImage *)closeButtonBGImage
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(25,25), NO, 0);
    
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Group 2
    {
        //// Bezier Drawing
        UIBezierPath* bezierPath = UIBezierPath.bezierPath;
        [bezierPath moveToPoint: CGPointMake(5.43, 5.43)];
        [bezierPath addCurveToPoint: CGPointMake(5.43, 19.57) controlPoint1: CGPointMake(1.52, 9.33) controlPoint2: CGPointMake(1.52, 15.67)];
        [bezierPath addCurveToPoint: CGPointMake(19.57, 19.57) controlPoint1: CGPointMake(9.33, 23.48) controlPoint2: CGPointMake(15.67, 23.48)];
        [bezierPath addCurveToPoint: CGPointMake(19.57, 5.43) controlPoint1: CGPointMake(23.48, 15.67) controlPoint2: CGPointMake(23.48, 9.33)];
        [bezierPath addCurveToPoint: CGPointMake(5.43, 5.43) controlPoint1: CGPointMake(15.67, 1.52) controlPoint2: CGPointMake(9.33, 1.52)];
        [bezierPath closePath];
        [bezierPath moveToPoint: CGPointMake(21.34, 3.66)];
        [bezierPath addCurveToPoint: CGPointMake(21.34, 21.34) controlPoint1: CGPointMake(26.22, 8.54) controlPoint2: CGPointMake(26.22, 16.46)];
        [bezierPath addCurveToPoint: CGPointMake(3.66, 21.34) controlPoint1: CGPointMake(16.46, 26.22) controlPoint2: CGPointMake(8.54, 26.22)];
        [bezierPath addCurveToPoint: CGPointMake(3.66, 3.66) controlPoint1: CGPointMake(-1.22, 16.46) controlPoint2: CGPointMake(-1.22, 8.54)];
        [bezierPath addCurveToPoint: CGPointMake(21.34, 3.66) controlPoint1: CGPointMake(8.54, -1.22) controlPoint2: CGPointMake(16.46, -1.22)];
        [bezierPath closePath];
        [UIColor.grayColor setFill];
        [bezierPath fill];
        
        
        //// Group
        {
            //// Rectangle Drawing
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, 7, 16.17);
            CGContextRotateCTM(context, -45 * M_PI / 180);
            
            UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, 12.96, 2.59) cornerRadius: 1.3];
            [UIColor.grayColor setFill];
            [rectanglePath fill];
            
            CGContextRestoreGState(context);
            
            
            //// Rectangle 2 Drawing
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, 8.83, 7);
            CGContextRotateCTM(context, 45 * M_PI / 180);
            
            UIBezierPath* rectangle2Path = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, 12.96, 2.59) cornerRadius: 1.3];
            [UIColor.grayColor setFill];
            [rectangle2Path fill];
            
            CGContextRestoreGState(context);
        }
    }
    
    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return im;
}

- (UIImage *)infoButtonBGImage
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(25,25), NO, 0);
    //// Color Declarations
    UIColor* color5 = [UIColor colorWithRed: 0 green: 0.478 blue: 1 alpha: 1];
    
    //// Bezier 2 Drawing
    UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
    [bezier2Path moveToPoint: CGPointMake(12.5, 5)];
    [bezier2Path addCurveToPoint: CGPointMake(11, 6.5) controlPoint1: CGPointMake(11.67, 5) controlPoint2: CGPointMake(11, 5.67)];
    [bezier2Path addLineToPoint: CGPointMake(11, 13.5)];
    [bezier2Path addCurveToPoint: CGPointMake(12.5, 15) controlPoint1: CGPointMake(11, 14.33) controlPoint2: CGPointMake(11.67, 15)];
    [bezier2Path addCurveToPoint: CGPointMake(14, 13.5) controlPoint1: CGPointMake(13.33, 15) controlPoint2: CGPointMake(14, 14.33)];
    [bezier2Path addLineToPoint: CGPointMake(14, 6.5)];
    [bezier2Path addCurveToPoint: CGPointMake(12.5, 5) controlPoint1: CGPointMake(14, 5.67) controlPoint2: CGPointMake(13.33, 5)];
    [bezier2Path closePath];
    [bezier2Path moveToPoint: CGPointMake(12.5, 16)];
    [bezier2Path addCurveToPoint: CGPointMake(11, 17.5) controlPoint1: CGPointMake(11.67, 16) controlPoint2: CGPointMake(11, 16.67)];
    [bezier2Path addCurveToPoint: CGPointMake(12.5, 19) controlPoint1: CGPointMake(11, 18.33) controlPoint2: CGPointMake(11.67, 19)];
    [bezier2Path addCurveToPoint: CGPointMake(14, 17.5) controlPoint1: CGPointMake(13.33, 19) controlPoint2: CGPointMake(14, 18.33)];
    [bezier2Path addCurveToPoint: CGPointMake(12.5, 16) controlPoint1: CGPointMake(14, 16.67) controlPoint2: CGPointMake(13.33, 16)];
    [bezier2Path closePath];
    [bezier2Path moveToPoint: CGPointMake(21.34, 3.66)];
    [bezier2Path addCurveToPoint: CGPointMake(21.34, 21.34) controlPoint1: CGPointMake(26.22, 8.54) controlPoint2: CGPointMake(26.22, 16.46)];
    [bezier2Path addCurveToPoint: CGPointMake(3.66, 21.34) controlPoint1: CGPointMake(16.46, 26.22) controlPoint2: CGPointMake(8.54, 26.22)];
    [bezier2Path addCurveToPoint: CGPointMake(3.66, 3.66) controlPoint1: CGPointMake(-1.22, 16.46) controlPoint2: CGPointMake(-1.22, 8.54)];
    [bezier2Path addCurveToPoint: CGPointMake(21.34, 3.66) controlPoint1: CGPointMake(8.54, -1.22) controlPoint2: CGPointMake(16.46, -1.22)];
    [bezier2Path closePath];
    [color5 setFill];
    [bezier2Path fill];

    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return im;
}

@end

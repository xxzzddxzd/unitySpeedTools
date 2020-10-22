#import "x5fPmvc.h"
#import "x5fPmgd.h"
#import "HBView.h"
#import "x5fPdb.h"
#import "x5fPsvc.h"
#import "p_inc.h"
//#import <HackClass.h>
extern struct callrel_sb * callrel_s;
extern struct callrel_ga * callrel_g;
extern float ep2;
extern float ep1;
extern float vF1;
bool autoSetSpeedOn = false;
bool switchAutoSpeed;
extern void startSearchAndInject();
extern void aSimpleUnhook(bool);
@interface x5fPmvc ()
<
UIGestureRecognizerDelegate,
x5fPsuicd
>
@property (retain, nonatomic) HBView *customView;
@property (retain, nonatomic) UIView *panelView;
@property (retain, nonatomic) x5fPdb *avatar;
@end

@implementation x5fPmvc

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    switchAutoSpeed =  [[self preread:@"sw_faston"] boolValue];
//    switchAutoSpeed = 1;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect bounds = [UIScreen mainScreen].bounds;

    self.view = [[HBView alloc] initWithFrame:self.view.frame];

    self.customView = [[HBView alloc] initWithFrame:bounds];
    self.customView.backgroundColor = [UIColor clearColor];
    self.customView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin
    | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:self.customView];
    XLog(@"1")
//    id<UIApplicationDelegate> app = [[UIApplication sharedApplication] delegate];
//    [app.window addSubview:self.customView];
    XLog(@"2")
    self.panelView = [[UIView alloc] initWithFrame:bounds];
    self.panelView.backgroundColor = [UIColor clearColor];
    self.panelView.hidden = YES;
    self.panelView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin
    | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:self.panelView];
//    [app.window addSubview:self.panelView];
//    [app.window addSubview:self.settingsVC.navigationController.view];
    [self.panelView addSubview:self.settingsVC.navigationController.view];
XLog(@"3")
    UITapGestureRecognizer *backgroundTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanelViewBackgroundTapEvent:)];
    backgroundTap.numberOfTouchesRequired = 1;
    backgroundTap.numberOfTapsRequired = 1;
    backgroundTap.delegate = self;
    [self.panelView addGestureRecognizer:backgroundTap];
    [backgroundTap release];

    // 悬浮按钮
    
    self.avatar = [[x5fPdb alloc] initInView:self.customView WithFrame:CGRectMake(CGRectGetWidth(self.customView.frame) - 45.0f, CGRectGetHeight(self.customView.frame) / 2 - 150.0f, 50, 60.0f)];
    [self.avatar setImage:[self avatarGBImage] forState:UIControlStateNormal];
    self.avatar.autoDocking = NO;
    [self.avatar addTarget:self action:@selector(toggleAppearPanel:) forControlEvents:UIControlEventTouchUpInside];
}
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    CGRect bounds = [UIScreen mainScreen].bounds;
//
//    self.view = [[HBView alloc] initWithFrame:self.view.frame];
//
//    self.customView = [[HBView alloc] initWithFrame:bounds];
//    self.customView.backgroundColor = [UIColor clearColor];
//    self.customView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin
//    | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
////    [self.view addSubview:self.customView];
//    XLog(@"1")
//    id<UIApplicationDelegate> app = [[UIApplication sharedApplication] delegate];
//    [app.window addSubview:self.customView];
//    XLog(@"2")
//    self.panelView = [[UIView alloc] initWithFrame:bounds];
//    self.panelView.backgroundColor = [UIColor clearColor];
//    self.panelView.hidden = YES;
//    self.panelView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin
//    | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
////    [self.view addSubview:self.panelView];
//    [app.window addSubview:self.panelView];
//    [app.window addSubview:self.settingsVC.navigationController.view];
////    [self.panelView addSubview:];
//XLog(@"3")
//    UITapGestureRecognizer *backgroundTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanelViewBackgroundTapEvent:)];
//    backgroundTap.numberOfTouchesRequired = 1;
//    backgroundTap.numberOfTapsRequired = 1;
//    backgroundTap.delegate = self;
//    [self.panelView addGestureRecognizer:backgroundTap];
//    [backgroundTap release];
//
//    // 悬浮按钮
//
//    self.avatar = [[x5fPdb alloc] initInView:self.customView WithFrame:CGRectMake(CGRectGetWidth(self.customView.frame) - 45.0f, CGRectGetHeight(self.customView.frame) / 2 - 150.0f, 50, 60.0f)];
//    [self.avatar setImage:[self avatarGBImage] forState:UIControlStateNormal];
//    self.avatar.autoDocking = NO;
//    [self.avatar addTarget:self action:@selector(toggleAppearPanel:) forControlEvents:UIControlEventTouchUpInside];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - Seter

- (void)setSettingsVC:(x5fPsvc *)settingsVC
{
    if (![_settingsVC isEqual:settingsVC]) {
        _settingsVC = settingsVC;
        _settingsVC.uiDelegate = self;
        CGRect bounds = [UIScreen mainScreen].bounds;

        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_settingsVC];
        [self addChildViewController:nav];
        
        nav.view.frame = CGRectMake(
                                    (CGRectGetWidth(bounds) - kModMainPanelWidth) / 2.0f,
                                    (CGRectGetHeight(bounds) - kModMainPanelHeight) / 2.0f,
                                    kModMainPanelWidth,
                                    kModMainPanelHeight);
        nav.view.layer.cornerRadius = 5.0f;
        nav.view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;

        [nav didMoveToParentViewController:self];
    }
}

#pragma mark - Action Handler

- (void)toggleAppearPanel:(id)sender
{
    if (self.avatar.isDragging) {
        return;
    }
    
    bool switchAutoSpeed =  [[self preread:@"sw_faston"] boolValue];
    
//    if (switchAutoSpeed) {
        XLog(@"touch button")
        XLog(@"gb_state:%d",gb_state)
        switch (gb_state) {
            case 0:{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                        message:@"Unity控速函数尚未确认，是否开始初始化？"
                                                                       delegate:self
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:@"取消",nil];
                        [alert show];
                        [alert release];
            }
                break;
            case 1:{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                            message:@"正在执行初始化，请稍后"
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                            [alert show];
                            [alert release];
                }
                break;
            case 2:
            case 3:{
                if([[self preread:@"sw_faston"] boolValue]){
                    [self.avatar setImage:[self avatarGBImageSpeedBio] forState:UIControlStateNormal];
                }else{
                    [self.avatar setImage:[self avatarGBImage] forState:UIControlStateNormal];
                    if ([self.avatar isHidden] && ![self.panelView isHidden]) {
                        self.avatar.hidden = NO;
                        self.panelView.hidden = YES;
                    }
                    else if (![self.avatar isHidden] && [self.panelView isHidden]) {
                        self.avatar.hidden = YES;
                        self.panelView.hidden = NO;
                    }
                }
                break;
            }

        }
//    }
//    else{
//        [self.avatar setImage:[self avatarGBImage] forState:UIControlStateNormal];
//        if ([self.avatar isHidden] && ![self.panelView isHidden]) {
//            self.avatar.hidden = NO;
//            self.panelView.hidden = YES;
//        }
//        else if (![self.avatar isHidden] && [self.panelView isHidden]) {
//            self.avatar.hidden = YES;
//            self.panelView.hidden = NO;
//        }
//    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    XLog(@"%ld", (long)buttonIndex);
    if (buttonIndex ==1 ){
        
        XLog(@"点击了取消")
    }
    else{
        XLog(@"开始执行注入")
        startSearchAndInject();
    }
    
}
- (void)handlePanelViewBackgroundTapEvent:(UITapGestureRecognizer *)sender
{
    CGPoint touch = [sender locationInView:self.panelView];

    CGRect validRect = self.settingsVC.navigationController.view.frame;
    if (!CGRectContainsPoint(validRect, touch)) {
        [self toggleAppearPanel:nil];
    }
}

#pragma mark - XXSetting Delegate
- (void)dismissSettingsViewControllerAction
{
    [self toggleAppearPanel:nil];
}

- (void)hideModeAction
{
    [self toggleAppearPanel:nil];
    self.avatar.hidden = YES;
}

#pragma mark - Gesture Recognizer Delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return ! ([touch.view isKindOfClass:[UIControl class]] || [NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"] || [touch.view.superview isKindOfClass:[UIControl class]]);
}

#pragma mark - Image
- (UIImage *)avatarGBImage
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(46,46), NO, 0);


    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* color = [UIColor colorWithCGColor:[UIColor redColor].CGColor];
    UIColor* color2 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0];
    
    //// Shadow Declarations
    UIColor* shadow = [UIColor.blackColor colorWithAlphaComponent: 0.53];
    CGSize shadowOffset = CGSizeMake(1.1, 4.1);
    CGFloat shadowBlurRadius = 2;
    
    //// Oval Drawing
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(2, 1, 40, 40)];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, [shadow CGColor]);
    [color2 setFill];
    [ovalPath fill];
    CGContextRestoreGState(context);
    
    [color setStroke];
    ovalPath.lineWidth = 2;
    [ovalPath stroke];
    
    
    //// Text Drawing
    CGRect textRect = CGRectMake(8, 14, 30, 17);
    [color setFill];
    [@"5KB" drawInRect: textRect withFont: [UIFont fontWithName: @"Helvetica-Bold" size: 13] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentCenter];


    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return im;
}

-(NSString * )preread:( NSString * )forKey
{
    NSString * path = D_PREFPATH;
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:path ];
    XLog(@"load preference %@",[dictionary objectForKey: forKey]);
    return [dictionary objectForKey: forKey];
}

- (UIImage *)avatarGBImageSpeedBio
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(46,46), NO, 0);
    
    
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* color = [UIColor colorWithCGColor:[UIColor redColor].CGColor];
    UIColor* color2 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0];
    
    //// Shadow Declarations
    UIColor* shadow = [UIColor.blackColor colorWithAlphaComponent: 0.53];
    CGSize shadowOffset = CGSizeMake(1.1, 4.1);
    CGFloat shadowBlurRadius = 2;
    
    //// Oval Drawing
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(2, 1, 40, 40)];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, [shadow CGColor]);
    [color2 setFill];
    [ovalPath fill];
    CGContextRestoreGState(context);
    
    [color setStroke];
    ovalPath.lineWidth = 2;
    [ovalPath stroke];
    
    
    //// Text Drawing
    CGRect textRect = CGRectMake(8, 14, 30, 17);
    [color setFill];
    if (autoSetSpeedOn == false) {
        aSimpleUnhook(1);
        gb_state=SP_INIT_DONE;
        autoSetSpeedOn = true;
//        NSLog(@"%d %d",[(NSNumber*)callrel_g->FUNC_GETPREFERENCE(@"sw_faston") boolValue] ,[(NSNumber*)callrel_g->FUNC_GETPREFERENCE(@"sc_jqsz") intValue]);
        float sc_jqsz = [[self preread:@"sc_jqsz"] floatValue];
        if (
//            [[self preread:@"sw_faston"] boolValue] &&
            [[self preread:@"sc_jqsz"] floatValue]>0) {
            vF1 = sc_jqsz;
            NSLog(@"get speed setting 1 %f",vF1);
        }else{
            vF1 = [[self preread:@"sc_f4"] floatValue];
            NSLog(@"get speed setting 2 %f",vF1);
        }

        [[NSString stringWithFormat:@"%f",vF1] drawInRect: textRect withFont: [UIFont fontWithName: @"Helvetica-Bold" size: 10] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentCenter];
        
        [x5fP ss1:1];
    }
    else{
        [x5fP ss1:0];
        autoSetSpeedOn = false;
        
        gb_state=SP_INIT_PAUSE;
        aSimpleUnhook(0);
        [@"暂停中" drawInRect: textRect withFont: [UIFont fontWithName: @"Helvetica-Bold" size: 10] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentCenter];
        
    }
    
    
    
    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return im;
}

- (BOOL)prefersStatusBarHidden
{
//    NSLog(@"********HIDDEN*********");
    return YES; //返回NO表示要显示，返回YES将hiden
}

@end

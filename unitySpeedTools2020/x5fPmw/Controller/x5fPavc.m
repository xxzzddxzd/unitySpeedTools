
#import "x5fPavc.h"
#import "x5fPmgd.h"




@interface hcavc : NSObject <UIAlertViewDelegate>

@end
@implementation hcavc
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"1");
}
@end


@interface x5fPavc ()
{
    NSString * rcmsg;
    NSString * popmsg;
    NSString * bdmsg;
    bool isLoaded;
    bool isInvited;
    int dp;
    int invc;
    int invCount;
}
@end

@implementation x5fPavc

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
    [self initView];
//    [self checkUIFS];
    UIScrollView *scrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake((kModMainPanelWidth - 225.0f) / 2.0f, CGRectGetHeight(self.customNavBar.frame), 225.0f, kModMainPanelHeight - CGRectGetHeight(self.customNavBar.frame))] autorelease];
    scrollView.backgroundColor = cColorMainView;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    bdmsg = bdmsg==nil?@"NULL":bdmsg;
    CGFloat contentHeight =[self heightForText:bdmsg font:[UIFont systemFontOfSize:16.0f] constraintWidth:CGRectGetWidth(scrollView.frame)];
    
    UILabel *contentLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(scrollView.frame), contentHeight)] autorelease];
    contentLabel.text = bdmsg;
    contentLabel.backgroundColor = cColorMainView;
    contentLabel.textColor = [UIColor whiteColor];
    contentLabel.font = [UIFont systemFontOfSize:16.0f];
    contentLabel.numberOfLines = 0;
    [self.view addSubview:contentLabel];

    scrollView.contentSize = CGSizeMake(CGRectGetWidth(scrollView.frame), contentHeight);
    [scrollView addSubview:contentLabel];
}

- (void)initView
{
    self.view.backgroundColor = cColorMainView;
    [self.navigationController setNavigationBarHidden:YES];
    self.navigationController.view.layer.cornerRadius = 2;
    self.navigationController.view.layer.borderColor = [self colorWithHexValue:0x999999 alpha:1].CGColor;
    self.navigationController.view.layer.borderWidth = 1.0f;
    self.navigationController.view.clipsToBounds = YES;
    
    self.customNavBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kModMainPanelWidth, 41)];
    self.customNavBar.backgroundColor = cColorMainView;
    [self.view addSubview:self.customNavBar];
    
    UILabel *title = [[UILabel alloc] initWithFrame:self.customNavBar.frame];
    title.backgroundColor = cColorMainView;
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont boldSystemFontOfSize:18.0f];
    title.text = kTextNavTitleAC;
    [self.customNavBar addSubview:title];
    
    UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnClose setTitle:@"返回" forState:UIControlStateNormal];
    [btnClose setBackgroundColor:[UIColor clearColor]];
    btnClose.frame = CGRectMake(0, 0, 45, 41);
    [btnClose setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [btnClose setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [btnClose addTarget:self action:@selector(customNavigationBarLeftItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.customNavBar addSubview:btnClose];
}

- (bool)isFirstLoad{
    return !isLoaded;
}

- (void)ainput:(NSString *)title msg:(NSString *)s cdele:(hcavc *)hack
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:s
                                                   delegate:hack
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alert show];
}

- (void)a:(NSString *)title  msg:(NSString *) s
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:s
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customNavigationBarLeftItemAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

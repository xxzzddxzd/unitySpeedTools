//
//  XXModCenter.m
//  XXModUIExample
//
//  Created by Hubert on 14-7-10.
//  Copyright (c) 2014年 Hubert. All rights reserved.
//

#import "x5fPmc.h"
#import "HBWindow.h"
#import "x5fPsvc.h"
#import "x5fPmvc.h"
#import "x5fPmco.h"
#import "x5fPmgd.h"
#import "p_inc.h"

//extern struct callrel_sb * callrel_s;
//extern struct callrel_ga * callrel_g;
extern float ep1;
extern float ep2;
extern enum SWTYPE speedType;
@interface x5fPmc ()
<
x5fPsd
>
@property (retain, nonatomic) HBWindow *centerWindow;
@property (retain, nonatomic) x5fPmvc *modRootVC;
@property (retain, nonatomic) x5fPsvc *settingsVC;
@property (retain, nonatomic) NSArray *dataSource;
@end

@implementation x5fPmc
+ (x5fPmc *)defaultCenter
{
    static x5fPmc * sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"defaultCenter 1");
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
-(NSString * )preread:( NSString * )forKey
{
    NSString * path = D_PREFPATH;
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:path ];
    return [dictionary objectForKey: forKey];
}
-(int) getParaCfg
{
    NSString * revStr;
    NSArray * naRecv = [revStr componentsSeparatedByString:@";"];
    NSArray * para = [[naRecv objectAtIndex:1] componentsSeparatedByString:@","];
    NSLog(@"%@",naRecv);
    NSLog(@"%@",para);
    p1 = -4;
    p2 = 30;
    ep1 = -4;
    ep2 = 30;
    if ([[self preread:@"sw_f4"] boolValue]) {
        if (p2>[[self preread:@"sc_f4"] intValue]) {
            p2 = [[self preread:@"sc_f4"] intValue];
        }
    }
    
    if (speedType==SW_COCO2D) {
        p1=1;
    }
    NSLog(@"getParaCfg 6");
    return 0;
}

- (id)init
{
    NSLog(@"fpmc init");
    self = [super init];
    if (self) {
       [self configuredDataSource];
        [self defaultSetting];
    }
    return self;
}

- (id)initWithSpport:(enum ENGINE_STATE)isSpport
{
    NSLog(@"initWithSpport %d",isSpport);
    switch (isSpport)
    {
        case SP_INIT_NIL:
            return NULL;
        case SP_INIT_WAIT:
            self = [super init];
            if (self) {
                [self configuredDataSource];
            }
            return self;
        case SP_INIT_DONE:{
            self = [super init];
            if (self) {
                [self configuredDataSource];
                [self defaultSetting];
            }
            return self;
        }
        default:
            return NULL;
    }
}

- (void)configuredDataSource
{
    self.dataSource = @[];
    x5fPmco *object00 = [[x5fPmco alloc] initSwitchTypeWithTitle:kTextRowTitle00 toggle:NO];
    x5fPmco *object01 = [[x5fPmco alloc] initSliderTypeWithTitle:kTextRowTitle01 value:1 defaultValue:1 minValue:p1 maxValue:p2];
//    x5fPmco *object02 = [[x5fPmco alloc] initSwitchTypeWithTitle:kTextRowTitle02 toggle:YES];
    
    NSArray *section0 = @[object00,object01];
    self.dataSource = @[section0,];
}

+ (void)showIcon
{
    NSLog(@"set show");
    static x5fPmc * mc = [self defaultCenter];
    mc.centerWindow.hidden = NO;
}

+ (void)hiddenIcon
{
    NSLog(@"set hidden");
    static x5fPmc * mc = [self defaultCenter];
    mc.centerWindow.hidden = YES;
}

- (void)defaultSetting
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidBecomeKeyNotification:) name:@"UIWindowDidBecomeKeyNotification" object:nil];
}

- (void)windowDidBecomeKeyNotification:(NSNotification *)notification
{
    if (!self.centerWindow) {
        
        self.centerWindow = [[HBWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.centerWindow.backgroundColor = [UIColor clearColor];
        
        self.modRootVC = [[x5fPmvc alloc] init];
        
        
        self.settingsVC = [[x5fPsvc alloc] initWithCells:self.dataSource];
        self.settingsVC.delegate = self;
        self.modRootVC.settingsVC = self.settingsVC;
        
        self.centerWindow.rootViewController = self.modRootVC;
        self.centerWindow.windowLevel = UIWindowLevelStatusBar;
        if (gb_state == SP_INIT_DONE) {
            self.centerWindow.hidden = NO;
        }
        
    }
}

- (void)dealloc
{
    [self.centerWindow release];
    [self.modRootVC release];
    [self.settingsVC release];
    [self.dataSource release];
    
    [super dealloc];
}

#pragma mark - Settings Delegate

- (NSString *)titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (NSString *)titleForFooterInSection:(NSInteger)section
{
    return nil;
}

- (NSString *)detailsStringWithFormat:(NSString *)value indexPath:(NSIndexPath *)indexPath
{
    float a = [value floatValue];
    if (a<1.0) {
        float len = ep1-1;
        a = a-1;
        a/=len;
        a=1-a;
        return [NSString stringWithFormat:@"减速至%.3f倍",a];
    }
    else{
        return [NSString stringWithFormat:@"增速至%.3f倍",a];
    }
    
//    return [NSString stringWithFormat:@"%.3f倍",a];
    return nil;
}

//界面设置反馈调用
- (void)detailsValue:(x5fPmco *)value settingAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        switch (indexPath.row) {
            case 0:
                [x5fP ss1:value.toggleValue];
                break;
            case 1:
                [x5fP ss2:value.sliderValue];
                break;
//            case 2:
//                [x5fP ss3:value.toggleValue];
//                break;
            default:
                break;
        }
    }
}

@end

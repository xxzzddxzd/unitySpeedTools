#import "p_inc.h"
#import <objc/objc-class.h>
//#import <SpringBoard/SBApplicationController.h>
#import "rocketbootstrap.h"
#import <CommonCrypto/CommonDigest.h>
#import <substrate.h>
#import "x5fPmc.h"
#import "x5fPmgd.h"
#import <mach/mach_init.h>
#import <mach/vm_map.h>
#import <mach/mach_port.h>
#import <mach-o/dyld.h>
#include <mach-o/getsect.h>
#import "spscapi.h"
#import "getU3dsystemfunc.h"
extern struct callrel_sb * callrel_s;
extern struct callrel_ga * callrel_g;

float ep1;
float ep2;
enum SWTYPE speedType = SW_NIL;
enum ENGINE_STATE gb_state = SP_INIT_NIL;


MY_BUNDLE MY_BUNDLE_S[1] = {
    {
        @"com.x5.unitySpeedTools",
        @"",
        @"",
        @"20190322",
        {
            1
        }
    }
};


static enum ENGINE_STATE setU3DHook();
static int getMap(void* dst, long* ad1, long *ad2);
static void findAddrInSection(long add1, long add2);
NSMutableArray * cptm, * cpts, *cptm64, *cpts64;
@interface x5fP()
{
    enum ENGINE_STATE x5state;
}

+ (x5fP *)sharedInstance;
@end


@implementation x5fP

+ (x5fP *)sharedInstance
{
    static x5fP *_ss = nil;
    if (_ss == nil) {
        _ss = [[x5fP alloc] init];
    }
    return _ss;
}

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}


+ (void)ss1:(bool)isOn{
    XLog(@"isOn() isF1 %d vF1 %f",isOn, vF1);
    isF1 = isOn;
    switch (speedType) {
        case SW_UNITY:
            cspeed64();
            break;
        case SW_COCO2D:
            cspeed64_cocos2dx();
            break;
        default:
            break;
    }
    
    
}

+ (void)ss2:(float)spValue{
    XLog(@"setVf1:%f isF1 %d,ep1:%f,ep2:%f",spValue,isF1,ep1,ep2);
    if (spValue>ep2) {
        spValue=ep2;
    }
    if (spValue<ep1) {
        spValue=ep1;
    }
    if (spValue<1.0&&ep1<1.0) {
        float len = ep1-1;
        spValue = spValue-1;
        spValue/=len;
        spValue=1-spValue;
    }
    
    
    //    XLog(@"setVf1:%f isF1 %d",spValue,isF1);
    vF1 = spValue;
    
    
    switch (speedType) {
        case SW_UNITY:
            cspeed64();
            break;
        case SW_COCO2D:
            cspeed64_cocos2dx();
            break;
        default:
            break;
    }
}

+ (bool)gs1{
    return isF1;
}
+ (float)gs2{
    return vF1;
}


@end

static enum ENGINE_STATE execSearch(){
    enum ENGINE_STATE rev = SP_INIT_NIL;
#if defined(_MAC64) || defined(__LP64__)
    cptm64 = [[NSMutableArray alloc] init];
    cpts64 = [[NSMutableArray alloc] init];
#else
    cptm = [[NSMutableArray alloc] init];
    cpts = [[NSMutableArray alloc] init];
#endif
    rev = setU3DHook();
    return rev;
}



void memPrint64(long start, long len, int type){
    XLog(@"memPrint64 start:0x%lx",start)
    long now = start;
    long end = start+len;
    while (now<=end) {
        if (type==1) {
            XLog(@"0x%lx\t\t%lx\t\t%lx", now, *(long*)(now), *(long*)(now+8));
        }
        else if(type==2)
        {
            XLog(@"0x%lx\t%f\t%f\t%f\t%f", now, *(float*)(now), *(float*)(now+4), *(float*)(now+8), *(float*)(now+12));
        }
        now+=16;
    }
}



NSMutableDictionary * addressDict = [[NSMutableDictionary alloc]init];
long u3dsystemfuncAddr64_addr[5];
long set_timeScale_addr[5];

void unhooku3dsystemfuncAddr64(){
    long thisAddr=u3dsystemfuncAddr64_addr[0];
    if (vm_protect(mach_task_self(), (vm_address_t) (thisAddr ), 0x10, 0, VM_PROT_READ | VM_PROT_WRITE | VM_PROT_COPY)== KERN_SUCCESS)
    {
        XLog(@"unhook u3dsystemfuncAddr64_addr")
        *(long *)(thisAddr) =u3dsystemfuncAddr64_addr[1];
        *(long *)(thisAddr+8) =u3dsystemfuncAddr64_addr[2];
        vm_protect(mach_task_self(), (vm_address_t) (thisAddr ), 0x10, 0, VM_PROT_READ  | VM_PROT_EXECUTE);
    }
}

extern "C" {
void aSimpleUnhook(bool isHook){
    if(speedType==SW_COCO2D){
        return;
    }
    XLog(@"set to hook=%d? 1=hook,0=unhook",isHook)
    long thisAddr=set_timeScale_addr[0];
    if (vm_protect(mach_task_self(), (vm_address_t) (thisAddr ), 0x10, 0, VM_PROT_READ | VM_PROT_WRITE | VM_PROT_COPY)== KERN_SUCCESS)
    {
        if (isHook==1) {
            XLog(@"hook set_timeScale_addr")
            *(long *)(thisAddr) =set_timeScale_addr[3];
            *(long *)(thisAddr+8) =set_timeScale_addr[4];
            XLog(@"hook set_timeScale_addr done")
            vm_protect(mach_task_self(), (vm_address_t) (thisAddr ), 0x10, 0, VM_PROT_READ  | VM_PROT_EXECUTE);
            gb_state=SP_INIT_DONE;
        }else{
            gb_state=SP_INIT_PAUSE;
            XLog(@"unhook set_timeScale_addr")
            *(long *)(thisAddr) =set_timeScale_addr[1];
            *(long *)(thisAddr+8) =set_timeScale_addr[2];
            XLog(@"unhook set_timeScale_addr done")
            vm_protect(mach_task_self(), (vm_address_t) (thisAddr ), 0x10, 0, VM_PROT_READ  | VM_PROT_EXECUTE);
        }
    }
}
}
static enum ENGINE_STATE setU3DHook(){
    //    enum ENGINE_STATE rev = SP_INIT_NIL;
    gb_state=SP_INIT_NIL;
    long u3dsystemfuncAddr64=0;
    u3dsystemfuncAddr64=dosearch();
    XLog(@"u3dsystemfuncAddr64 %lx",u3dsystemfuncAddr64)
    if (u3dsystemfuncAddr64){
        u3dsystemfuncAddr64_addr[0]=(u3dsystemfuncAddr64);
        u3dsystemfuncAddr64_addr[1]=*(long*)(u3dsystemfuncAddr64);
        u3dsystemfuncAddr64_addr[2]=*(long*)(u3dsystemfuncAddr64+8);
        MSHookFunction((void *)(u3dsystemfuncAddr64), (void *)ne_u3dsystemfunc, (void **)&u3dsystemfunc);
        u3dsystemfuncAddr64_addr[3]=*(long*)(u3dsystemfuncAddr64);
        u3dsystemfuncAddr64_addr[4]=*(long*)(u3dsystemfuncAddr64+8);
        gb_state=SP_INIT_WAIT;
        XLog(@"setU3DHook set gb_state %d",gb_state);
        XLog(@"here0")
        long revaddr = ne_u3dsystemfunc("UnityEngine.Time::set_timeScale(System.Single)");
        XLog(@"here1")
        unhooku3dsystemfuncAddr64();
        XLog(@"here2")
        XLog(@"found set_timeScale:0x%lx",revaddr);
        if(revaddr){
            memPrint64(revaddr,0x20,1);
            set_timeScale_addr[0]=(revaddr);
            set_timeScale_addr[1]=*(long*)(revaddr);
            set_timeScale_addr[2]=*(long*)(revaddr+8);
            MSHookFunction((void *)(revaddr), (void *)ne_sys_speed_control, (void **)&sys_speed_control);
            set_timeScale_addr[3]=*(long*)(revaddr);
            set_timeScale_addr[4]=*(long*)(revaddr+8);
            memPrint64(revaddr,0x20,1);
            gb_state=SP_INIT_DONE;
            XLog(@"setU3DHook set gb_state %d",gb_state);
            aSimpleUnhook(1);
        }
    }
    return gb_state;
}

static NSString * preread(NSString * forKey)
{
    NSString * path = D_PREFPATH;
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:path ];
    XLog(@"load preference %@",[dictionary objectForKey: forKey]);
    return [dictionary objectForKey: forKey];
}


/***********************end******************************/

extern long (*sys_speed_control)(float);
extern long ne_sys_speed_control(float a1);
/*******************Hook Functions***********************/
%hook UnityView
- (void)touchesBegan:(id)touches withEvent:(id)event{
    //    XLog(@"touchesBegan %d %lx",gb_state,sys_speed_control);
    //    if(gb_state==2 && sys_speed_control){
    //        XLog(@"show x5 icon")
    //        [x5fPmc showIcon];
    //    }
    //    XLog(@"show x5 icon")
    [x5fPmc showIcon];
    %orig;
}
%end
extern "C" {
void startSearchAndInject(){
    if (gb_state>=1) {
        XLog(@"gb_state:%d，不为0，不进行重复的搜索操作",gb_state)
        return;
    }
    dispatch_queue_t queue = dispatch_queue_create("1212", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        gb_state=SP_INIT_WAIT;
        XLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        XLog(@"Loading UnitySpeedTools for unity engine")
        if([preread(@"sw_f1") boolValue]){
            speedType = SW_UNITY;
            XLog(@"#########2");
            execSearch();
            XLog(@"--- init rev %d ---", gb_state);
        }
    });
}
}
long doLoadFramework();
void constructor() __attribute__((constructor));
void constructor(void)
{
    XLog(@"Loading UnitySpeedTools for unity engine, delay 30s")
    doLoadFramework();
    
    //dispatch_queue_t queue = dispatch_queue_create("1212", DISPATCH_QUEUE_CONCURRENT);
    //    dispatch_async(queue, ^{
    //        // 追加任务 1
    //        [NSThread sleepForTimeInterval:40];              // 模拟耗时操作
    //        XLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
    //        XLog(@"Loading UnitySpeedTools for unity engine")
    //            if([preread(@"sw_f1") boolValue]){
    //              speedType = SW_UNITY;
    //              XLog(@"#########2");
    //              execSearch();
    //              XLog(@"--- init rev %d ---", gb_state);
    //            }
    //    });
    
}


//#import "/usr/include/Availability.h"
%hook UnityAppController
//
-(BOOL)application:(id)application didFinishLaunchingWithOptions:(id)options
{
    XLog(@"-(BOOL)application:(id)application didFinishLaunchingWithOptions:(id)options")
    startSearchAndInject();
    [x5fPmc defaultCenter];
    
    return %orig;
}
%end
#import <UIKit/UIKit.h>
NSString * getFilePath() {
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [documentPaths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"bundleIDs.plist"];
}
NSString * getBundleID() {
    return [[NSBundle mainBundle] bundleIdentifier];
}
void saveBundleIDConfirmation(id confirmation) {
    NSString *bundleID = getBundleID();
    NSString *filePath = getFilePath();
    
    NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSMutableDictionary *savedData = [NSMutableDictionary dictionaryWithDictionary:data];
    
    if (!savedData) {
        savedData = [NSMutableDictionary dictionary];
    }
    
    [savedData setObject:confirmation forKey:bundleID];
    [savedData writeToFile:filePath atomically:YES];
}

void showChoiced(){
    // 弹出确认框
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认"
                                                                                 message:@"是否确认该 Bundle ID？"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        //    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认"
        //                                                                             message:@"是否确认该 Bundle ID？"
        //                                                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"是"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
            saveBundleIDConfirmation(@"YES");
        }];
        UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"否"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action) {
            saveBundleIDConfirmation(@"NO");
        }];
        
        UIAlertAction *disableAction = [UIAlertAction actionWithTitle:@"禁用"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction *action) {
            saveBundleIDConfirmation(@"AB");
        }];
        
        [alertController addAction:yesAction];
        [alertController addAction:noAction];
        [alertController addAction:disableAction];
        
        [rootViewController presentViewController:alertController animated:YES completion:nil];
    });
}
extern  int (*orig_gettimeofday)(struct timeval * __restrict, void * __restrict);
extern  int mygettimeofday(struct timeval*tv,struct timezone *tz );


//#include <sys/time.h>
//%hook AppController
//- (BOOL)application:(id)application didFinishLaunchingWithOptions:(id)launchOptions {
//    NSString *filePath = getFilePath(); // 获取文件路径
//
//    // 检查文件是否存在
//    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
//        NSDictionary *savedData = [NSDictionary dictionaryWithContentsOfFile:filePath];
//        NSString *bundleID = getBundleID();
//
//        // 检查文件中是否已经记录了该 Bundle ID
//        id savedopt = [savedData objectForKey:bundleID];
//        if (savedopt) {
//            // 已记录，不再弹框
//            XLog(@"Bundle ID: %@ 已经记录, key is %@", bundleID, savedopt);
//            if ([savedopt isEqualToString:@"AB"]) {
//                return %orig; // 禁用，直接返回
//            }
//            else if ([savedopt isEqualToString:@"YES"]) {
//                // 执行加速
//                // 获取应用程序的委托对象
////                XLog(@"_gettimeofday %lx",MSFindSymbol(NULL,"_gettimeofday"))
////                MSHookFunction((void *)MSFindSymbol(NULL,"_gettimeofday"), (void *)mygettimeofday, (void **)&orig_gettimeofday);
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    // 获取应用程序的主窗口
//                    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
//
//                    // 创建并显示自动消失的提示框
//                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"
//                                                                                             message:@"已开启"
//                                                                                      preferredStyle:UIAlertControllerStyleAlert];
//
//                    [mainWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
//
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        [alertController dismissViewControllerAnimated:YES completion:nil];
//                    });
//
//                });
////                XLog(@"_gettimeofday %lx",MSFindSymbol("/usr/lib/libc++.1.dylib","_gettimeofday"))
//                MSHookFunction((void *)gettimeofday, (void *)mygettimeofday, (void **)&orig_gettimeofday);;
//                speedType=SW_COCO2D;
//                gb_state=SP_INIT_DONE;
//                [x5fPmc defaultCenter];
//                [x5fPmc showIcon];
//                return %orig;
//            } else{
//                showChoiced();
//            }
//            return %orig;
//        }
//    }else{
//        showChoiced();
//    }
//
//
//    return %orig;
//}
//
//%end

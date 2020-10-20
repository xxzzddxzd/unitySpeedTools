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
#if defined(_MAC64) || defined(__LP64__)
            cspeed64();
#else
            cspeed32();
#endif
            break;
        case SW_COCO2D:
            cspeedCocoa2d();
            break;
        default:
            break;
    }
    

}

+ (void)ss2:(float)spValue{
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


    XLog(@"setVf1:%f isF1 %d",spValue,isF1);
    vF1 = spValue;
    
    
    switch (speedType) {
        case SW_UNITY:
#if defined(_MAC64) || defined(__LP64__)
            cspeed64();
#else
            cspeed32();
#endif
            break;
        case SW_COCO2D:
            cspeedCocoa2d();
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

/* 应对Framework形式Unity*/
long doLoadFramework(){
//    XLog(@"###############JBDETECT##################");
    id a =[NSBundle mainBundle];
    id path = [a bundlePath];
    id bp = [path stringByAppendingString:@"/Frameworks/UnityFramework.framework"];
    id c =[NSBundle bundleWithPath:bp];
    [c load];
    long alsr=0;
    
    for (int i=0; i<_dyld_image_count(); i++) {
        
        if ([[NSString stringWithUTF8String:_dyld_get_image_name(i) ]  containsString:@"UnityFramework.framework/UnityFramework"]) {
            XLog(@"%d,%s",i,_dyld_get_image_name(i));
            alsr= _dyld_get_image_vmaddr_slide(i);
        }
    }
    if (alsr==0) {
        XLog(@"not framework mode")
        alsr=_dyld_get_image_vmaddr_slide(0);
    }
    
    XLog(@"alsr  %lx",alsr);
    return alsr;
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
extern "C" {
void aSimpleUnhook(bool isHook){
    XLog(@"set to hook=%d? 1=hook,0=unhook",isHook)
    long thisAddr=u3dsystemfuncAddr64_addr[0];
    memPrint64(thisAddr,0x20,1);
    
    if (vm_protect(mach_task_self(), (vm_address_t) (thisAddr ), 0x10, 0, VM_PROT_READ | VM_PROT_WRITE | VM_PROT_COPY)== KERN_SUCCESS)
    {
        if (isHook==1) {
            XLog(@"hook u3dsystemfuncAddr64_addr")
            *(long *)(thisAddr) =u3dsystemfuncAddr64_addr[3];
            *(long *)(thisAddr+8) =u3dsystemfuncAddr64_addr[4];
        }else{
            XLog(@"unhook u3dsystemfuncAddr64_addr")
            *(long *)(thisAddr) =u3dsystemfuncAddr64_addr[1];
            *(long *)(thisAddr+8) =u3dsystemfuncAddr64_addr[2];
        }
        vm_protect(mach_task_self(), (vm_address_t) (thisAddr ), 0x10, 0, VM_PROT_READ  | VM_PROT_EXECUTE);
    }
    memPrint64(thisAddr,0x20,1);
    thisAddr=set_timeScale_addr[0];
    memPrint64(thisAddr,0x20,1);
    if (vm_protect(mach_task_self(), (vm_address_t) (thisAddr ), 0x10, 0, VM_PROT_READ | VM_PROT_WRITE | VM_PROT_COPY)== KERN_SUCCESS)
    {
        if (isHook==1) {
            XLog(@"hook set_timeScale_addr")
            *(long *)(thisAddr) =set_timeScale_addr[3];
            *(long *)(thisAddr+8) =set_timeScale_addr[4];
            XLog(@"hook set_timeScale_addr done")
        }else{
            XLog(@"unhook set_timeScale_addr")
            *(long *)(thisAddr) =set_timeScale_addr[1];
            *(long *)(thisAddr+8) =set_timeScale_addr[2];
            XLog(@"unhook set_timeScale_addr done")
        }
        vm_protect(mach_task_self(), (vm_address_t) (thisAddr ), 0x10, 0, VM_PROT_READ  | VM_PROT_EXECUTE);
    }
    memPrint64(thisAddr,0x20,1);
}
}
static enum ENGINE_STATE setU3DHook(){
    enum ENGINE_STATE rev = SP_INIT_NIL;
#if defined(_MAC64) || defined(__LP64__)
    long u3dsystemfuncAddr64=0;
    u3dsystemfuncAddr64=dosearch();
    XLog(@"u3dsystemfuncAddr64 %lx",u3dsystemfuncAddr64)
    if (u3dsystemfuncAddr64){
        memPrint64(u3dsystemfuncAddr64,0x20,1);
        u3dsystemfuncAddr64_addr[0]=(u3dsystemfuncAddr64);
        u3dsystemfuncAddr64_addr[1]=*(long*)(u3dsystemfuncAddr64);
        u3dsystemfuncAddr64_addr[2]=*(long*)(u3dsystemfuncAddr64+8);
//        addressDict[@"u3dsystemfuncAddr64"][@"ori"]=@[*(long*)(u3dsystemfuncAddr64),*(long*)(u3dsystemfuncAddr64+8)];
        MSHookFunction((void *)(u3dsystemfuncAddr64), (void *)ne_u3dsystemfunc, (void **)&u3dsystemfunc);
        u3dsystemfuncAddr64_addr[3]=*(long*)(u3dsystemfuncAddr64);
        u3dsystemfuncAddr64_addr[4]=*(long*)(u3dsystemfuncAddr64+8);
        memPrint64(u3dsystemfuncAddr64,0x20,1);
        gb_state=SP_INIT_WAIT;
        XLog(@"setU3DHook set gb_state %d",gb_state);
//        dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//        dispatch_async(queue, ^{
//            sleep(3);
//            long revaddr = ne_u3dsystemfunc("UnityEngine.Time::set_timeScale(System.Single)");
//            XLog(@"found set_timeScale:0x%lx",revaddr);
//            if(revaddr){
//                memPrint64(revaddr,0x20,1);
//                set_timeScale_addr[0]=(revaddr);
//                set_timeScale_addr[1]=*(long*)(revaddr);
//                set_timeScale_addr[2]=*(long*)(revaddr+8);
//                MSHookFunction((void *)(revaddr), (void *)ne_sys_speed_control, (void **)&sys_speed_control);
//                set_timeScale_addr[3]=*(long*)(revaddr);
//                set_timeScale_addr[4]=*(long*)(revaddr+8);
//                memPrint64(revaddr,0x20,1);
//                gb_state=SP_INIT_DONE;
//                XLog(@"setU3DHook set gb_state %d",gb_state);
//                aSimpleUnhook(1);
//            }
//        });
        long revaddr = ne_u3dsystemfunc("UnityEngine.Time::set_timeScale(System.Single)");
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
#else
//    long timeScaleHookAddr=0,timeManagerHookAddr=0;
//
//    timeManagerHookAddr = getTimeManager32(add1,add2);
//    if (timeManagerHookAddr==0) {
//        timeScaleHookAddr = getTimeScale32(add1,add2);
//    }
//    else{
//        timeScaleHookAddr = getTimeScale32(timeManagerHookAddr+idr,timeManagerHookAddr+0x2000+idr);
//    }
//
//
//    //如果有这个函数则必须要hook，防止系统控速
//    if (timeScaleHookAddr!=0){
//        XLog(@"####### 32 add timeScale %lx %lx",idr,timeScaleHookAddr);
//        MSHookFunction((void *)(idr+timeScaleHookAddr +1), (void *)ne_x5TimeScale, (void **)&x5TimeScale);
//        rev = SP_INIT_WAIT;
//    }
//    if (timeManagerHookAddr!=0){
//        XLog(@"####### 32 add timeManager %lx %lx",idr,timeManagerHookAddr);
//        MSHookFunction((void *)(idr+timeManagerHookAddr +1), (void *)ne_x5TimeManager, (void **)&x5TimeManager);
//        rev = SP_INIT_DONE;
//    }
#endif


    return rev;
}

static NSString * preread(NSString * forKey)
{
    NSString * path = D_PREFPATH;
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:path ];
    XLog(@"load preference %@",[dictionary objectForKey: forKey]);
    return [dictionary objectForKey: forKey];
}


/***********************end******************************/

typedef void (^x5audtdbl)(void);
@interface x5audcla : NSObject
{
    
}
+(void)x5audTd:(x5audtdbl) block;
@end


@implementation x5audcla
static x5audcla *threadOperation = nil;
- (void)perfrombgg:(x5audtdbl) block {
    @autoreleasepool {
        block();
    }
}

+(void)x5audTd:(x5audtdbl) block
{
    XLog(@"######LODING X5AUDTD######");
    @synchronized(threadOperation) {
        if(threadOperation == nil) {
            threadOperation = [[x5audcla alloc] init];
        }
    }
    [NSThread detachNewThreadSelector:@selector(perfrombgg:) toTarget:threadOperation withObject:[[block copy] autorelease]];
}
@end

int (*_gettime)(struct timeval *tp, struct timezone *tzp);
int (*_old_gettime)(struct timeval *tp, struct timezone *tzp);
int new_gettime(struct timeval *tp, struct timezone *tzp);

static void setHookSpeed()
{
    _gettime = (int (*)(struct timeval *, struct timezone *))MSFindSymbol(NULL,"_gettimeofday");
    NSLog(@"###############%lx",(long)_gettime);
    MSHookFunction((void *)(_gettime), (void *)new_gettime, (void **)&_old_gettime);
}


#define USECSCALE   (1000000LL)
int speed_coco2d = 1;

static int64_t  lastUSecs;  /* for accumulate speedup time,  microseconds */
static int64_t  lastOrigUSecs = 0;  /* for accumulate speedup time,  microseconds */


int new_gettime(struct timeval *tp, struct timezone *tzp)
{
    int result = _old_gettime(tp, tzp);
    //    NSLog(@"===============tp->tv_sec=%li",tp->tv_sec);
    //    NSLog(@"===============tp->tv_sec=%d",tp->tv_usec);
    //    NSLog(@"===============result=%d",result);
    if(result != 0)
        return result;
    
    /* first run, init pLastUpdate
     * tv_sec :     uint32_t
     * tv_usec :    int32_t
     */
    if( lastOrigUSecs != 0) {
        
        int64_t currentUSecs = (tp->tv_sec ) * USECSCALE + tp->tv_usec;
        int64_t dt =  currentUSecs - lastOrigUSecs;
        
        lastOrigUSecs = currentUSecs;
        lastUSecs += (dt * speed_coco2d*1000) / 1000;
        
        //        LOGD("xx_gettimeofday dt:%lld", dt*1000);
        tp->tv_sec = lastUSecs / USECSCALE;
        tp->tv_usec = lastUSecs - (tp->tv_sec * USECSCALE );
        
        
    } else {
        lastOrigUSecs = tp->tv_sec * USECSCALE + tp->tv_usec;
        /* last  microseconds since Jan. 1, 1970  */
        lastUSecs = tp->tv_sec * USECSCALE + tp->tv_usec;
        
    }
    return result;
}
extern long (*sys_speed_control)(float);
extern long ne_sys_speed_control(float a1);
/*******************Hook Functions***********************/
%hook UnityView
- (void)touchesBegan:(id)touches withEvent:(id)event{
    XLog(@"touchesBegan %d %lx",gb_state,sys_speed_control);
//    if(gb_state==2 && sys_speed_control){
//        XLog(@"show x5 icon")
//        [x5fPmc showIcon];
//    }
    XLog(@"show x5 icon")
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
            // 追加任务 1
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

void constructor() __attribute__((constructor));
void constructor(void)
{
    XLog(@"Loading UnitySpeedTools for unity engine, delay 30s")
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
    [x5fPmc defaultCenter];
    return %orig;
}
%end
//
//
//%hook AppController
//-(BOOL)application:(id)application didFinishLaunchingWithOptions:(id)options
//{
//
//    if([preread(@"sw_f2") boolValue]){
//        speedType = SW_COCO2D;
//        XLog(@"#########2");
//        XLog(@"--- init rev %d ---", gb_state);
//        [x5fPmc defaultCenter];
//        setHookSpeed();
//        gb_state = SP_INIT_DONE;
//    }
//    return %orig;
//
//}
//%end
//
//%hook AppDelegate
//-(BOOL)application:(id)application didFinishLaunchingWithOptions:(id)options
//{
//
//
//    if([preread(@"sw_f3") boolValue]){
//        speedType = SW_COCO2D;
//        XLog(@"#########2");
//        XLog(@"--- init rev %d ---", gb_state);
//        [x5fPmc defaultCenter];
//        setHookSpeed();
//        gb_state = SP_INIT_DONE;
//    }
//    return %orig;
//
//}
//%end
//
//%hook SgeAppDelegate
//-(BOOL)application:(id)application didFinishLaunchingWithOptions:(id)options
//{
//    if([preread(@"sw_f3") boolValue]){
//        speedType = SW_COCO2D;
//        XLog(@"#########2");
//        XLog(@"--- init rev %d ---", gb_state);
//        [x5fPmc defaultCenter];
//        setHookSpeed();
//        gb_state = SP_INIT_DONE;
//    }
//    return %orig;
//
//}
//%end
//
//%hook SoulCollectorAppDelegate
//-(BOOL)application:(id)application didFinishLaunchingWithOptions:(id)options
//{
//
//    if([preread(@"sw_f3") boolValue]){
//        speedType = SW_COCO2D;
//        XLog(@"#########2");
//        XLog(@"--- init rev %d ---", gb_state);
//        [x5fPmc defaultCenter];
//        setHookSpeed();
//        gb_state = SP_INIT_DONE;
//    }
//    return %orig;
//
//}
//%end
//%hook CTAppController
//-(BOOL)application:(id)application didFinishLaunchingWithOptions:(id)options
//{
//    if([preread(@"sw_f3") boolValue]){
//        speedType = SW_COCO2D;
//        XLog(@"#########2");
//        XLog(@"--- init rev %d ---", gb_state);
//        [x5fPmc defaultCenter];
//        setHookSpeed();
//        gb_state = SP_INIT_DONE;
//    }
//    return %orig;
//
//}
//%end

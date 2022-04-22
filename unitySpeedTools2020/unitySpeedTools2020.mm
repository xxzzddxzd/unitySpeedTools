#line 1 "/Users/xuzhengda/Documents/GitHub/unitySpeedTools/unitySpeedTools2020/unitySpeedTools2020.xm"
#import "p_inc.h"
#import <objc/objc-class.h>

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


+ (x5fP *)sharedInstance {
    static x5fP *_ss = nil;
    if (_ss == nil) {
        _ss = [[x5fP alloc] init];
    }
    return _ss;
}


- (id)init {
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



    vF1 = spValue;
    
    
    switch (speedType) {
        case SW_UNITY:
            cspeed64();
            break;
        case SW_COCO2D:
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




extern long (*sys_speed_control)(float);
extern long ne_sys_speed_control(float a1);


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class UnityView; @class UnityAppController; 
static void (*_logos_orig$_ungrouped$UnityView$touchesBegan$withEvent$)(_LOGOS_SELF_TYPE_NORMAL UnityView* _LOGOS_SELF_CONST, SEL, id, id); static void _logos_method$_ungrouped$UnityView$touchesBegan$withEvent$(_LOGOS_SELF_TYPE_NORMAL UnityView* _LOGOS_SELF_CONST, SEL, id, id); static BOOL (*_logos_orig$_ungrouped$UnityAppController$application$didFinishLaunchingWithOptions$)(_LOGOS_SELF_TYPE_NORMAL UnityAppController* _LOGOS_SELF_CONST, SEL, id, id); static BOOL _logos_method$_ungrouped$UnityAppController$application$didFinishLaunchingWithOptions$(_LOGOS_SELF_TYPE_NORMAL UnityAppController* _LOGOS_SELF_CONST, SEL, id, id); 

#line 252 "/Users/xuzhengda/Documents/GitHub/unitySpeedTools/unitySpeedTools2020/unitySpeedTools2020.xm"

static void _logos_method$_ungrouped$UnityView$touchesBegan$withEvent$(_LOGOS_SELF_TYPE_NORMAL UnityView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id touches, id event){
    XLog(@"touchesBegan %d %lx",gb_state,sys_speed_control);




    XLog(@"show x5 icon")
    [x5fPmc showIcon];
    _logos_orig$_ungrouped$UnityView$touchesBegan$withEvent$(self, _cmd, touches, event);
}

extern "C" {
void startSearchAndInject(){
    if (gb_state>=1) {
        XLog(@"gb_state:%d，不为0，不进行重复的搜索操作",gb_state)
        return;
    }
    dispatch_queue_t queue = dispatch_queue_create("1212", DISPATCH_QUEUE_CONCURRENT);
        dispatch_async(queue, ^{
            gb_state=SP_INIT_WAIT;
            XLog(@"1---%@",[NSThread currentThread]);      
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













    
}





static BOOL _logos_method$_ungrouped$UnityAppController$application$didFinishLaunchingWithOptions$(_LOGOS_SELF_TYPE_NORMAL UnityAppController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id application, id options) {
    XLog(@"-(BOOL)application:(id)application didFinishLaunchingWithOptions:(id)options")
    startSearchAndInject();
    [x5fPmc defaultCenter];
    
    return _logos_orig$_ungrouped$UnityAppController$application$didFinishLaunchingWithOptions$(self, _cmd, application, options);
}

static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$UnityView = objc_getClass("UnityView"); { MSHookMessageEx(_logos_class$_ungrouped$UnityView, @selector(touchesBegan:withEvent:), (IMP)&_logos_method$_ungrouped$UnityView$touchesBegan$withEvent$, (IMP*)&_logos_orig$_ungrouped$UnityView$touchesBegan$withEvent$);}Class _logos_class$_ungrouped$UnityAppController = objc_getClass("UnityAppController"); { MSHookMessageEx(_logos_class$_ungrouped$UnityAppController, @selector(application:didFinishLaunchingWithOptions:), (IMP)&_logos_method$_ungrouped$UnityAppController$application$didFinishLaunchingWithOptions$, (IMP*)&_logos_orig$_ungrouped$UnityAppController$application$didFinishLaunchingWithOptions$);}} }
#line 318 "/Users/xuzhengda/Documents/GitHub/unitySpeedTools/unitySpeedTools2020/unitySpeedTools2020.xm"

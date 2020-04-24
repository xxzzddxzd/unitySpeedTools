#line 1 "/Users/xuzhengda/Documents/unitySpeedTools2020/unitySpeedTools/unitySpeedTools2020/unitySpeedTools2020.xm"
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


static enum ENGINE_STATE setU3DHook(long ad1, long ad2);
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
    long *ad1, *ad2;
    ad1 = (long*)malloc(sizeof(long));
    ad2 = (long*)malloc(sizeof(long));
    *ad2=0;
    enum ENGINE_STATE rev = SP_INIT_NIL;
#if defined(_MAC64) || defined(__LP64__)
    cptm64 = [[NSMutableArray alloc] init];
    cpts64 = [[NSMutableArray alloc] init];
#else
    cptm = [[NSMutableArray alloc] init];
    cpts = [[NSMutableArray alloc] init];
#endif
    while (getMap((void*)(*ad2),ad1,ad2) != 0) {
        rev = setU3DHook(*ad1,*ad2);
        if (rev == SP_INIT_WAIT || rev == SP_INIT_DONE) {
            break;
        }
    }
    return rev;
}

#define kerncall(x) ({ \
kern_return_t _kr = (x); \
if(_kr != KERN_SUCCESS) \
fprintf(stderr, "%s failed with error code: 0x%x\n", #x, _kr); \
_kr; \
})
extern "C" kern_return_t mach_vm_region
(
 vm_map_t target_task,
 vm_address_t *address,
 vm_size_t *size,
 vm_region_flavor_t flavor,
 vm_region_info_t info,
 mach_msg_type_number_t *infoCnt,
 mach_port_t *object_name
 );

static int getMap(void* dst, long* ad1, long *ad2){
    mach_port_t task;
    int rev = 0;
    vm_address_t region = (vm_address_t)dst;
    vm_size_t region_size = 0;
#if defined(_MAC64) || defined(__LP64__)
    vm_region_basic_info_data_64_t info;
    mach_msg_type_number_t info_count = VM_REGION_BASIC_INFO_COUNT_64;
    vm_region_flavor_t flavor = VM_REGION_BASIC_INFO_64;
    if (mach_vm_region(mach_task_self(), &region, &region_size, flavor, (vm_region_info_t)&info, (mach_msg_type_number_t*)&info_count, (mach_port_t*)&task) != KERN_SUCCESS)
    {
        return rev;
    }
    else{
        rev = 64;
    }
#else
    vm_region_basic_info_data_t info;
    mach_msg_type_number_t info_count = VM_REGION_BASIC_INFO_COUNT;
    vm_region_flavor_t flavor = VM_REGION_BASIC_INFO;
    if (vm_region(mach_task_self(), &region, &region_size, flavor, (vm_region_info_t)&info, (mach_msg_type_number_t*)&info_count, (mach_port_t*)&task) != KERN_SUCCESS)
    {
        return rev;
    }
    else{
        rev = 32;
    }
#endif
    *ad1 =region;
    *ad2 =region + region_size;
    if (info.protection<1) {
        return 0;
    }
    return rev;
}

static enum ENGINE_STATE setU3DHook(long add1, long add2)
{
    long idr = _dyld_get_image_vmaddr_slide(0);
    enum ENGINE_STATE rev = SP_INIT_NIL;


#if defined(_MAC64) || defined(__LP64__)
    long timeScaleHookAddr64=0,timeManagerNewHook64=0,timeManagerHookAddr64=0;
    long u3dsystemfuncAddr64=0;
    

































    u3dsystemfuncAddr64 = getU3dsystemfunc(add1,add2);
    if (u3dsystemfuncAddr64){
        MSHookFunction((void *)(idr+u3dsystemfuncAddr64), (void *)ne_u3dsystemfunc, (void **)&u3dsystemfunc);
        rev = SP_INIT_WAIT;
        dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            
            sleep(3);
            long revaddr = ne_u3dsystemfunc("UnityEngine.Time::set_timeScale(System.Single)");
            XLog(@"ne_u3dsystemfunc----0x%lx",revaddr);
            if(revaddr){
                MSHookFunction((void *)(revaddr), (void *)ne_sys_speed_control, (void **)&sys_speed_control);
                
                gb_state=SP_INIT_DONE;
                XLog(@"set gb_state %d",gb_state);
            }
            
            
        });
    }
#else
    long timeScaleHookAddr=0,timeManagerHookAddr=0;
    
    timeManagerHookAddr = getTimeManager32(add1,add2);
    if (timeManagerHookAddr==0) {
        timeScaleHookAddr = getTimeScale32(add1,add2);
    }
    else{
        timeScaleHookAddr = getTimeScale32(timeManagerHookAddr+idr,timeManagerHookAddr+0x2000+idr);
    }
    

    
    if (timeScaleHookAddr!=0){
        XLog(@"####### 32 add timeScale %lx %lx",idr,timeScaleHookAddr);
        MSHookFunction((void *)(idr+timeScaleHookAddr +1), (void *)ne_x5TimeScale, (void **)&x5TimeScale);
        rev = SP_INIT_WAIT;
    }
    if (timeManagerHookAddr!=0){
        XLog(@"####### 32 add timeManager %lx %lx",idr,timeManagerHookAddr);
        MSHookFunction((void *)(idr+timeManagerHookAddr +1), (void *)ne_x5TimeManager, (void **)&x5TimeManager);
        rev = SP_INIT_DONE;
    }
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


+(void)x5audTd:(x5audtdbl) block {
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

static int64_t  lastUSecs;  
static int64_t  lastOrigUSecs = 0;  


int new_gettime(struct timeval *tp, struct timezone *tzp)
{
    int result = _old_gettime(tp, tzp);
    
    
    
    if(result != 0)
        return result;
    
    



    if( lastOrigUSecs != 0) {
        
        int64_t currentUSecs = (tp->tv_sec ) * USECSCALE + tp->tv_usec;
        int64_t dt =  currentUSecs - lastOrigUSecs;
        
        lastOrigUSecs = currentUSecs;
        lastUSecs += (dt * speed_coco2d*1000) / 1000;
        
        
        tp->tv_sec = lastUSecs / USECSCALE;
        tp->tv_usec = lastUSecs - (tp->tv_sec * USECSCALE );
        
        
    } else {
        lastOrigUSecs = tp->tv_sec * USECSCALE + tp->tv_usec;
        
        lastUSecs = tp->tv_sec * USECSCALE + tp->tv_usec;
        
    }
    return result;
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

@class CTAppController; @class SoulCollectorAppDelegate; @class UnityAppController; @class AppController; @class SgeAppDelegate; @class UnityView; @class AppDelegate; 
static void (*_logos_orig$_ungrouped$UnityView$touchesBegan$withEvent$)(_LOGOS_SELF_TYPE_NORMAL UnityView* _LOGOS_SELF_CONST, SEL, id, id); static void _logos_method$_ungrouped$UnityView$touchesBegan$withEvent$(_LOGOS_SELF_TYPE_NORMAL UnityView* _LOGOS_SELF_CONST, SEL, id, id); static BOOL (*_logos_orig$_ungrouped$UnityAppController$application$didFinishLaunchingWithOptions$)(_LOGOS_SELF_TYPE_NORMAL UnityAppController* _LOGOS_SELF_CONST, SEL, id, id); static BOOL _logos_method$_ungrouped$UnityAppController$application$didFinishLaunchingWithOptions$(_LOGOS_SELF_TYPE_NORMAL UnityAppController* _LOGOS_SELF_CONST, SEL, id, id); static BOOL (*_logos_orig$_ungrouped$AppController$application$didFinishLaunchingWithOptions$)(_LOGOS_SELF_TYPE_NORMAL AppController* _LOGOS_SELF_CONST, SEL, id, id); static BOOL _logos_method$_ungrouped$AppController$application$didFinishLaunchingWithOptions$(_LOGOS_SELF_TYPE_NORMAL AppController* _LOGOS_SELF_CONST, SEL, id, id); static BOOL (*_logos_orig$_ungrouped$AppDelegate$application$didFinishLaunchingWithOptions$)(_LOGOS_SELF_TYPE_NORMAL AppDelegate* _LOGOS_SELF_CONST, SEL, id, id); static BOOL _logos_method$_ungrouped$AppDelegate$application$didFinishLaunchingWithOptions$(_LOGOS_SELF_TYPE_NORMAL AppDelegate* _LOGOS_SELF_CONST, SEL, id, id); static BOOL (*_logos_orig$_ungrouped$SgeAppDelegate$application$didFinishLaunchingWithOptions$)(_LOGOS_SELF_TYPE_NORMAL SgeAppDelegate* _LOGOS_SELF_CONST, SEL, id, id); static BOOL _logos_method$_ungrouped$SgeAppDelegate$application$didFinishLaunchingWithOptions$(_LOGOS_SELF_TYPE_NORMAL SgeAppDelegate* _LOGOS_SELF_CONST, SEL, id, id); static BOOL (*_logos_orig$_ungrouped$SoulCollectorAppDelegate$application$didFinishLaunchingWithOptions$)(_LOGOS_SELF_TYPE_NORMAL SoulCollectorAppDelegate* _LOGOS_SELF_CONST, SEL, id, id); static BOOL _logos_method$_ungrouped$SoulCollectorAppDelegate$application$didFinishLaunchingWithOptions$(_LOGOS_SELF_TYPE_NORMAL SoulCollectorAppDelegate* _LOGOS_SELF_CONST, SEL, id, id); static BOOL (*_logos_orig$_ungrouped$CTAppController$application$didFinishLaunchingWithOptions$)(_LOGOS_SELF_TYPE_NORMAL CTAppController* _LOGOS_SELF_CONST, SEL, id, id); static BOOL _logos_method$_ungrouped$CTAppController$application$didFinishLaunchingWithOptions$(_LOGOS_SELF_TYPE_NORMAL CTAppController* _LOGOS_SELF_CONST, SEL, id, id); 

#line 400 "/Users/xuzhengda/Documents/unitySpeedTools2020/unitySpeedTools/unitySpeedTools2020/unitySpeedTools2020.xm"

static void _logos_method$_ungrouped$UnityView$touchesBegan$withEvent$(_LOGOS_SELF_TYPE_NORMAL UnityView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id touches, id event){
    XLog(@"touchesBegan %d %lx",gb_state,sys_speed_control);
    if(gb_state==2 && sys_speed_control){
        [x5fPmc showIcon];
    }
    _logos_orig$_ungrouped$UnityView$touchesBegan$withEvent$(self, _cmd, touches, event);
}






static BOOL _logos_method$_ungrouped$UnityAppController$application$didFinishLaunchingWithOptions$(_LOGOS_SELF_TYPE_NORMAL UnityAppController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id application, id options) {
        if([preread(@"sw_f1") boolValue]){
            speedType = SW_UNITY;
            XLog(@"#########2");
            execSearch();
            XLog(@"--- init rev %d ---", gb_state);
            [x5fPmc defaultCenter];
        }
    
    return _logos_orig$_ungrouped$UnityAppController$application$didFinishLaunchingWithOptions$(self, _cmd, application, options);
}





static BOOL _logos_method$_ungrouped$AppController$application$didFinishLaunchingWithOptions$(_LOGOS_SELF_TYPE_NORMAL AppController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id application, id options) {
    
    if([preread(@"sw_f2") boolValue]){
        speedType = SW_COCO2D;
        XLog(@"#########2");
        XLog(@"--- init rev %d ---", gb_state);
        [x5fPmc defaultCenter];
        setHookSpeed();
        gb_state = SP_INIT_DONE;
    }
    return _logos_orig$_ungrouped$AppController$application$didFinishLaunchingWithOptions$(self, _cmd, application, options);
    
}




static BOOL _logos_method$_ungrouped$AppDelegate$application$didFinishLaunchingWithOptions$(_LOGOS_SELF_TYPE_NORMAL AppDelegate* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id application, id options) {
    
    
    if([preread(@"sw_f3") boolValue]){
        speedType = SW_COCO2D;
        XLog(@"#########2");
        XLog(@"--- init rev %d ---", gb_state);
        [x5fPmc defaultCenter];
        setHookSpeed();
        gb_state = SP_INIT_DONE;
    }
    return _logos_orig$_ungrouped$AppDelegate$application$didFinishLaunchingWithOptions$(self, _cmd, application, options);
    
}




static BOOL _logos_method$_ungrouped$SgeAppDelegate$application$didFinishLaunchingWithOptions$(_LOGOS_SELF_TYPE_NORMAL SgeAppDelegate* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id application, id options) {
    if([preread(@"sw_f3") boolValue]){
        speedType = SW_COCO2D;
        XLog(@"#########2");
        XLog(@"--- init rev %d ---", gb_state);
        [x5fPmc defaultCenter];
        setHookSpeed();
        gb_state = SP_INIT_DONE;
    }
    return _logos_orig$_ungrouped$SgeAppDelegate$application$didFinishLaunchingWithOptions$(self, _cmd, application, options);
    
}




static BOOL _logos_method$_ungrouped$SoulCollectorAppDelegate$application$didFinishLaunchingWithOptions$(_LOGOS_SELF_TYPE_NORMAL SoulCollectorAppDelegate* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id application, id options) {

    if([preread(@"sw_f3") boolValue]){
        speedType = SW_COCO2D;
        XLog(@"#########2");
        XLog(@"--- init rev %d ---", gb_state);
        [x5fPmc defaultCenter];
        setHookSpeed();
        gb_state = SP_INIT_DONE;
    }
    return _logos_orig$_ungrouped$SoulCollectorAppDelegate$application$didFinishLaunchingWithOptions$(self, _cmd, application, options);
    
}



static BOOL _logos_method$_ungrouped$CTAppController$application$didFinishLaunchingWithOptions$(_LOGOS_SELF_TYPE_NORMAL CTAppController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id application, id options) {
    if([preread(@"sw_f3") boolValue]){
        speedType = SW_COCO2D;
        XLog(@"#########2");
        XLog(@"--- init rev %d ---", gb_state);
        [x5fPmc defaultCenter];
        setHookSpeed();
        gb_state = SP_INIT_DONE;
    }
    return _logos_orig$_ungrouped$CTAppController$application$didFinishLaunchingWithOptions$(self, _cmd, application, options);
    
}

static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$UnityView = objc_getClass("UnityView"); MSHookMessageEx(_logos_class$_ungrouped$UnityView, @selector(touchesBegan:withEvent:), (IMP)&_logos_method$_ungrouped$UnityView$touchesBegan$withEvent$, (IMP*)&_logos_orig$_ungrouped$UnityView$touchesBegan$withEvent$);Class _logos_class$_ungrouped$UnityAppController = objc_getClass("UnityAppController"); MSHookMessageEx(_logos_class$_ungrouped$UnityAppController, @selector(application:didFinishLaunchingWithOptions:), (IMP)&_logos_method$_ungrouped$UnityAppController$application$didFinishLaunchingWithOptions$, (IMP*)&_logos_orig$_ungrouped$UnityAppController$application$didFinishLaunchingWithOptions$);Class _logos_class$_ungrouped$AppController = objc_getClass("AppController"); MSHookMessageEx(_logos_class$_ungrouped$AppController, @selector(application:didFinishLaunchingWithOptions:), (IMP)&_logos_method$_ungrouped$AppController$application$didFinishLaunchingWithOptions$, (IMP*)&_logos_orig$_ungrouped$AppController$application$didFinishLaunchingWithOptions$);Class _logos_class$_ungrouped$AppDelegate = objc_getClass("AppDelegate"); MSHookMessageEx(_logos_class$_ungrouped$AppDelegate, @selector(application:didFinishLaunchingWithOptions:), (IMP)&_logos_method$_ungrouped$AppDelegate$application$didFinishLaunchingWithOptions$, (IMP*)&_logos_orig$_ungrouped$AppDelegate$application$didFinishLaunchingWithOptions$);Class _logos_class$_ungrouped$SgeAppDelegate = objc_getClass("SgeAppDelegate"); MSHookMessageEx(_logos_class$_ungrouped$SgeAppDelegate, @selector(application:didFinishLaunchingWithOptions:), (IMP)&_logos_method$_ungrouped$SgeAppDelegate$application$didFinishLaunchingWithOptions$, (IMP*)&_logos_orig$_ungrouped$SgeAppDelegate$application$didFinishLaunchingWithOptions$);Class _logos_class$_ungrouped$SoulCollectorAppDelegate = objc_getClass("SoulCollectorAppDelegate"); MSHookMessageEx(_logos_class$_ungrouped$SoulCollectorAppDelegate, @selector(application:didFinishLaunchingWithOptions:), (IMP)&_logos_method$_ungrouped$SoulCollectorAppDelegate$application$didFinishLaunchingWithOptions$, (IMP*)&_logos_orig$_ungrouped$SoulCollectorAppDelegate$application$didFinishLaunchingWithOptions$);Class _logos_class$_ungrouped$CTAppController = objc_getClass("CTAppController"); MSHookMessageEx(_logos_class$_ungrouped$CTAppController, @selector(application:didFinishLaunchingWithOptions:), (IMP)&_logos_method$_ungrouped$CTAppController$application$didFinishLaunchingWithOptions$, (IMP*)&_logos_orig$_ungrouped$CTAppController$application$didFinishLaunchingWithOptions$);} }
#line 510 "/Users/xuzhengda/Documents/unitySpeedTools2020/unitySpeedTools/unitySpeedTools2020/unitySpeedTools2020.xm"

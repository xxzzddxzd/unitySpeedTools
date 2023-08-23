
#include "spscapi.h"
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



extern int speed_coco2d;
#if defined(_MAC64) || defined(__LP64__)
long (*x5TimeScalex64)(long,float);
long (*x5TimeManagerx64)(long);
long (*x5TimeManagerNew)();
long lastR0x64=0;
unsigned char pyad_speed=0;
#else
int (*x5TimeScale)(int r0, int r1);
int (*x5TimeManager)(int);
long lastR0=0;
#endif

bool isF1=false;
float vF1=1;
float maxSp = 10;
float minSp = 0;

//    timemanager 32位
//    9FED 082A B4EE C20A
//    timemanager 64位
//    60A2 0091 7F96 00B9
//    加速32位
//    41EC 101B 9FED 132A    (+0x672)
//    加速64位
//    211ea80000540820201e6b
//    0xec41, 0x1b10, 0xed9f, 0x2a13, 0x1e212000, 0x540000a8, 0x1e202008
//    0xec41, 0x1b10, 0xed9f, 0x2a13, 0x2000, 0x1e21, 0xa8, 0x5400, 0x2008, 0x1e20, 0xed9f, 0x2a08, 0xeeb4, 0x0ac2, 0xa260, 0x9100, 0x967f, 0xb900, 0x10e2
//    0 32位                                     3||4           64位                                                  9||10 32位manager                     13||14 64位manager                    17||


/*
 变速执行函数 - unity3d
 */
void cspeed64(){
//    if(gb_state == SP_INIT_DONE){
    float k = vF1;
    if (!isF1) {
        k=1.0;
    }
    ne_sys_speed_control(k);
}

long (*u3dsystemfunc)(char*);
long ne_u3dsystemfunc(char * a1){
    //XLog(@"u3dsystemfunc call %s",a1);
    return u3dsystemfunc(a1);
}
/*
 此处的设定是为了防止系统调用发生非人为的变速
 */
long (*sys_speed_control)(float);
long ne_sys_speed_control(float a1){
    XLog(@"sys_speed_control set speed %f",a1);
    float k = vF1;
    if (!isF1) {
        k=1.0;
    }
    
    return sys_speed_control(k);
}
void (*sys_set_targetFrameRate)(long);
void ne_sys_set_targetFrameRate(long a1){
    sys_set_targetFrameRate(a1);
    XLog(@"set_targetFrameRate %ld",a1)
//    return rev;
}
long (*sys_get_targetFrameRate)();
long ne_sys_get_targetFrameRate(){
    long rev=sys_get_targetFrameRate();
    XLog(@"get_targetFrameRate %ld",rev)
    return rev;
}

/*
 变速执行函数 - unity3d
 */
int SPEEDLEVEL=1;
void cspeed64_cocos2dx(){
    int k = vF1;
    if (!isF1) {
        k=1;
    }
    XLog(@"set cocos2dx speed to %d",k)
    SPEEDLEVEL=2;
}


 int (*orig_gettimeofday)(struct timeval * __restrict, void * __restrict);
 int mygettimeofday(struct timeval*tv,struct timezone *tz ) {
    int ret = orig_gettimeofday(tv,tz);
    if (ret == 0) {
        tv->tv_usec *= SPEEDLEVEL;
        tv->tv_sec *= SPEEDLEVEL;
    }
    return ret;
}

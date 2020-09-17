
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


#if defined(_MAC64) || defined(__LP64__)

long getTimeManager64(long in_start, long in_end){
    XLog(@"\n------------getTimeManager64--------------");
    long idr=_dyld_get_image_vmaddr_slide(0);
    long now = in_start;
    long end = in_end;
    long rev = 0;
    long temprev = 0;
    unsigned short s64ma1 = MY_BUNDLE_S[0].paraAddr[ARRAY_START_TM64]&0xffff;
    unsigned short s64ma2 = MY_BUNDLE_S[0].paraAddr[ARRAY_START_TM64+1]&0xffff;
    unsigned short s64ma3 = MY_BUNDLE_S[0].paraAddr[ARRAY_START_TM64+2]&0xffff;
    unsigned short s64ma4 = MY_BUNDLE_S[0].paraAddr[ARRAY_START_TM64+3]&0xffff;
    short s64functionHead = 0x4ff4;
    XLog(@"start Searching timeManager in 64bit%x %x %x %x",s64ma1,s64ma2,s64ma3,s64ma4);
    XLog(@"now 0x%lx-0x%lx idr %lx",now,end,idr);
    while ((long)now<end-6){
        if(*(short*)(now)==(short)s64ma1){
            //                                XLog(@"#%lx",now-idr);
            if(*(short*)(now+2)==(short)s64ma2){
                //                                        XLog(@"##%lx",now-idr);
                if(*(short*)(now+4)==(short)s64ma3){
                    XLog(@"###%lx",now-idr);
                    if(*(short*)(now+6)==(short)s64ma4){
                        temprev = now;
                    }
                }
            }
        }
        now+=1;
    }
    if(temprev!=0){
        now = temprev;
        while (now>temprev-0x40) {
            if(*(short*)(now)==(short)s64functionHead){
                rev = now - idr;
                XLog(@"#######64 FOUND timeManager in %lx",now-idr);
            }
//             [[NSRunLoop currentRunLoop] run];
            now-=1;
        }
    }
    return rev;
}

//FD7B BFA9 FD03 0091 E00B 0032 .... .... FD7B C1A8 c003 5fd6
long getTimeManagerNew(long in_start,long in_end){
    XLog(@"\n------------getTimeManagerNew--------------");
    long idr=_dyld_get_image_vmaddr_slide(0);
    long now = in_start;
    long end = in_end;
    long rev = 0;
    long temprev = 0;
//    unsigned short s64ma1 = MY_BUNDLE_S[0].paraAddr[14]&0xffff;
//    unsigned short s64ma2 = MY_BUNDLE_S[0].paraAddr[15]&0xffff;
//    unsigned short s64ma3 = MY_BUNDLE_S[0].paraAddr[16]&0xffff;
//    unsigned short s64ma4 = MY_BUNDLE_S[0].paraAddr[17]&0xffff;
//    ushort a1 = 0x7bfd,a2= 0xa9bf,a3 =0x3FD,a4 =0x9100,a5 =0xBe0,a6 =0x3200,a7 =0x7bfd,a8 =0xa8c1,a9 =0x3c0,a10 =0xd65f;
    ushort a1 = MY_BUNDLE_S[0].paraAddr[ARRAY_START_TMN64]&0xffff;
    ushort a2 = MY_BUNDLE_S[0].paraAddr[ARRAY_START_TMN64+1]&0xffff;
    ushort a3 = MY_BUNDLE_S[0].paraAddr[ARRAY_START_TMN64+2]&0xffff;
    ushort a4 = MY_BUNDLE_S[0].paraAddr[ARRAY_START_TMN64+3]&0xffff;
    ushort a5 = MY_BUNDLE_S[0].paraAddr[ARRAY_START_TMN64+4]&0xffff;
    ushort a6 = MY_BUNDLE_S[0].paraAddr[ARRAY_START_TMN64+5]&0xffff;
    ushort a7 = MY_BUNDLE_S[0].paraAddr[ARRAY_START_TMN64+6]&0xffff;
    ushort a8 = MY_BUNDLE_S[0].paraAddr[ARRAY_START_TMN64+7]&0xffff;
    ushort a9 = MY_BUNDLE_S[0].paraAddr[ARRAY_START_TMN64+8]&0xffff;
    ushort a10 = MY_BUNDLE_S[0].paraAddr[ARRAY_START_TMN64+9]&0xffff;
    XLog(@"\tstart Searching timeManager in 64bit%x %x %x %x",a1,a2,a3,a4);
    XLog(@"\tnow 0x%lx-0x%lx idr %lx",now,end,idr);
    while ((long)now<end-22){
        if(*(short*)(now)==(short)a1)
            if(*(short*)(now+2)==(short)a2)
                if(*(short*)(now+4)==(short)a3)
                    if(*(short*)(now+6)==(short)a4){
                        if(*(short*)(now+8)==(short)a5)
                            if(*(short*)(now+10)==(short)a6)
                                if(*(short*)(now+16)==(short)a7)
                                    if(*(short*)(now+18)==(short)a8)
                                        if(*(short*)(now+20)==(short)a9)
                                            if(*(short*)(now+22)==(short)a10){
                                                XLog(@"check1 %lx",now-idr);
                                                temprev = now;
                                            }
                            }
        now+=1;
    }
    if(temprev!=0){
        rev = temprev - idr;
        XLog(@"#######64 FOUND timeManagerNew in %lx %lx",temprev,idr );
    }
    return rev;
}

long getTimeScale64(long in_start, long in_end){
    XLog(@"\n------------getTimeScale64--------------");
    long idr=_dyld_get_image_vmaddr_slide(0);
    long now = in_start;
    long end = in_end;
    long rev = 0;
    short s64_6 = MY_BUNDLE_S[0].paraAddr[ARRAY_START_TS64]&0xffff;
    short s64_7 = MY_BUNDLE_S[0].paraAddr[ARRAY_START_TS64+1]&0xffff;
    short s64_8 = MY_BUNDLE_S[0].paraAddr[ARRAY_START_TS64+2]&0xffff;
    short s64_9 = MY_BUNDLE_S[0].paraAddr[ARRAY_START_TS64+3]&0xffff;
    short s64_a = MY_BUNDLE_S[0].paraAddr[ARRAY_START_TS64+4]&0xffff;
    short s64_b = MY_BUNDLE_S[0].paraAddr[ARRAY_START_TS64+5]&0xffff;
    XLog(@"\tstart Searching timeScale in 64bit%x %x %x %x %x %x",s64_6,s64_7,s64_8,s64_9,s64_a,s64_b);
    XLog(@"\tnow 0x%lx-0x%lx idr %lx",now,end,idr);
//    if (now<0x100100000) {
//        return 0;
//    }
    while ((long)now<end-6){
        if(*(short*)(now)==(short)s64_6){
//            XLog(@"#%lx",now-idr);
            if(*(short*)(now+2)==(short)s64_7){
//                XLog(@"##%lx",now-idr);
                if(*(short*)(now+4)==(short)s64_8){
//                    XLog(@"###%lx",now-idr);
                    if(*(short*)(now+6)==(short)s64_9 && *(short*)(now+8)==(short)s64_a && *(short*)(now+10)==(short)s64_b){
                        XLog(@"#######64 FOUND speedScale in %lx",now-idr-8);
                        rev = now-idr-8;
                        if( (*(int*)(now+18)&0xbd00) == 0xbd00){   // sign  str        s0, [x0, #0xf4]
                            
                            pyad_speed = *(unsigned char*)(now+17);
                            XLog(@"###%hx %x", *(short*)(now+16),pyad_speed);
                        }
                    }
                }
            }
        }
        now+=1;
    }
    return rev;
}
#else
int getTimeManager32(int in_start, int in_end){
    int idr=_dyld_get_image_vmaddr_slide(0);
    int now = in_start;
    int end = in_end;
    int rev = 0;
    unsigned short s6 = MY_BUNDLE_S[0].paraAddr[ARRAY_START_TM32]&0xffff;
    unsigned short s7 = MY_BUNDLE_S[0].paraAddr[ARRAY_START_TM32+1]&0xffff;
    unsigned short s8 = MY_BUNDLE_S[0].paraAddr[ARRAY_START_TM32+2]&0xffff;
    unsigned short s9 = MY_BUNDLE_S[0].paraAddr[ARRAY_START_TM32+3]&0xffff;
    
    XLog(@"start Searching timeManager in 32bit %x %x %x %x ",s6,s7,s8,s9);
    XLog(@"now 0x%x-0x%x idr %x",in_start,in_end,idr);
    while ((int)now<end-6){
        if (now>0x500000)
        {
            if(*(short*)(now)==(short)s6){
                //                XLog(@"#%x",now-idr);
                if(*(short*)(now+2)==(short)s7){
                    //                    XLog(@"####%x",now-idr);
                    if(*(short*)( now+4)==(short)s8){
                        //                        XLog(@"########%x",now-idr);
                        if(*(short*)(now+6)==(short)s9){
                            XLog(@"#######32 FOUND timeManager in %x",now-idr+0x28);
                            rev = now-idr+0x28;
                            //                            break;
                        }
                    }
                }
            }
        }
        
        now+=1;
    }
    XLog(@" ");
    return rev;
}

int getTimeScale32(int in_start, int in_end){
    int idr=_dyld_get_image_vmaddr_slide(0);
    int now = in_start;
    int end = in_end;
    int rev = 0;
    unsigned short s2 = MY_BUNDLE_S[0].paraAddr[ARRAY_START_TS32]&0xffff;
    unsigned short s3 = MY_BUNDLE_S[0].paraAddr[ARRAY_START_TS32+1]&0xffff;
    unsigned short s4 = MY_BUNDLE_S[0].paraAddr[ARRAY_START_TS32+2]&0xffff;
    unsigned short s5 = MY_BUNDLE_S[0].paraAddr[ARRAY_START_TS32+3]&0x0ff0;
//    unsigned char *s6 = (unsigned char*)(&s5 );
    XLog(@"start Searching timeScale in 32bit %x %x %x %x ",s2,s3,s4,s5);
    XLog(@"now 0x%x-0x%x idr %x\n\n",now,end,idr);
    while ((int)now<end-6){
        if(*(short*)(now)==(short)s2){
            //            XLog(@"#%x",now-idr);
            if(*(short*)(now+2)==(short)s3){
                //                XLog(@"####%x",now-idr);
                if(*(short*)(now+4)==(short)s4){
                    //                    XLog(@"########%x",now-idr);
                    
                    if((*(short*)(now+6)&0x0ff0)==(short)s5){
//                    XLog(@"########%x %x",*(unsigned char *)(now+6),*(unsigned char *)(now+7));
//                    if(*(unsigned char *)(now+7)==*(s6+1)){
                        XLog(@"#######32 FOUND speedScale in %x",now-idr-6);
                        rev = now-idr-6;
                    }
                }
            }
        }
        now+=1;
    }
    XLog(@" ");
    return rev;
}
#endif

/*
 变速执行函数
 */
#if defined(_MAC64) || defined(__LP64__)
void cspeed64(){
    float k = vF1;
    if (!isF1) {
        k=1.0;
    }
    /*
    if (pyad_speed) {
            *(float*)(lastR0x64+pyad_speed) = k;
    }else{
        *(float*)(lastR0x64+0xcc) = k;
    }*/
    ne_sys_speed_control(k);
}
#else
void cspeed32(){
    float k = vF1;
    if (!isF1) {
        k=1.0;
    }
    XLog(@"set speed %f", k);
    *(int*)(lastR0+0xb8) = *(int*)(&k);
}
#endif

void cspeedCocoa2d(){
    if (!isF1) {
        speed_coco2d=1;
    }
    else{
        speed_coco2d = (int)vF1;
    }
    XLog(@"set speed %d",speed_coco2d);
}

/*
 此处获取lastR0地址，只由系统调用
 由于Hook了流程函数，关闭时走原速度，打开时走设定速度
 */
#if defined(_MAC64) || defined(__LP64__)
//20211ea80000540820201e6b
long ne_x5TimeScalex64(long x0, float x1)
{
   // XLog(@"#############x64x64x64x64 %ld %f",*(long*)(x0+0xcc),x1);
    if (lastR0x64 == 0) {
        lastR0x64 = x0;
        gb_state = SP_INIT_DONE;
        [x5fPmc showIcon];
    }
    cspeed64();
    return 0;
}
#else
////41EC101B9FED132A
int ne_x5TimeScale(int r0, int r1)
{
    //XLog(@"#############x32x32x32x32x32 r0:%x lastR0:%lx %f",r0, lastR0, vF1);
    if (lastR0 == 0) {
        lastR0 = r0;
        gb_state = SP_INIT_DONE;
        [x5fPmc showIcon];
    }
    cspeed32();
    return 0;
}
#endif

/*
 此处获取lastR0地址，只由系统调用
 */
#if defined(_MAC64) || defined(__LP64__)

long ne_x5TimeManagerx64(long r0){
    long rev = x5TimeManagerx64(r0);
    //XLog(@"*******************In TimeManagerx64 r0 0x%lx, rev 0x%lx",r0, rev);
    lastR0x64=r0;
    return rev;
}
#else
int ne_x5TimeManager(int r0){
    int rev = x5TimeManager(r0);
    //XLog(@"*******************In TimeManager r0 0x%x, rev 0x%x",r0, rev);
    lastR0=r0;
    return rev;
}
#endif


/*
 此处获取lastR0地址，自行调用
 */
#if defined(_MAC64) || defined(__LP64__)
long ne_x5TimeManagerNew(){
    long rev = x5TimeManagerNew();
    //XLog(@"*******************In x5TimeManagerNew rev 0x%lx", rev);
    lastR0x64=rev;
    return rev;
}
#endif


/*
 
 */
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

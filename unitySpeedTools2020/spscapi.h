#ifndef spscapi_h
#define spscapi_h

#include <stdio.h>

#if defined(_MAC64) || defined(__LP64__)
extern long lastR0x64;
extern long (*x5TimeScalex64)(long,float);
extern long (*x5TimeManagerx64)(long);
extern long (*x5TimeManagerNew)();
void cspeed64();
long ne_x5TimeScalex64(long x0,float x1);
long ne_x5TimeManagerx64(long r0);
long ne_x5TimeManagerNew();
long getTimeManager64(long in_start, long in_end);
long getTimeScale64(long in_start, long in_end);
long getTimeManagerNew(long in_start,long in_end);
extern long (*u3dsystemfunc)(char*);
long ne_u3dsystemfunc(char * a1);
extern long (*sys_speed_control)(float);
long ne_sys_speed_control(float a1);

#else
extern long lastR0;
extern int (*x5TimeScale)(int r0, int r1);
extern int (*x5TimeManager)(int);
void cspeed32();
int ne_x5TimeScale(int r0, int r1);
int ne_x5TimeManager(int r0);
int  getTimeManager32(int in_start, int in_end);
int  getTimeScale32(int in_start, int in_end);
#endif

extern bool isF1;
extern float vF1;
void cspeedCocoa2d();

extern void (*sys_set_targetFrameRate)(long);
void ne_sys_set_targetFrameRate(long a1);
extern long (*sys_get_targetFrameRate)();
long ne_sys_get_targetFrameRate();
/*
 ------20180717
 0xec41,0x1b10,0xed9f,0x2a13,0x2000,0x1e21,0xa8,0x5400,0x2008,0x1e20,0xed9f,0x2a08,0xeeb4,0x0ac2,0x7bfd,0xa9bf,0x3FD,0x9100,0xBe0,0x3200,0x7bfd,0xa8c1,0x3c0,0xd65f
 ||20180717 - 14位起的manager特征值变化，数组共25，
 
 ------20180718
 0xec41,0x1b10,0xed9f,0x2a13,
 |ts32 0-3
 0x2000,0x1e21,0xa8,0x5400,0x2008,0x1e20,
 |ts64 4-9
 0xed9f,0x2a08,0xeeb4,0x0ac2,
 |tm32 10-13
 0xa260, 0x9100, 0x967f, 0xb900
 |tm64 14-17
 0x7bfd,0xa9bf,0x3FD,0x9100,0xBe0,0x3200,0x7bfd,0xa8c1,0x3c0,0xd65f
 |tmn64 18-27
 */
#define ARRAY_START_TS32 0
#define ARRAY_START_TS64 4
#define ARRAY_START_TM32 10
#define ARRAY_START_TM64 14
#define ARRAY_START_TMN64 18
#endif /* spscapi_h */

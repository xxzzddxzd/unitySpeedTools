//
//  getU3dsystemfunc.m
//  unitySpeedTools
//
//  Created by 徐正达 on 2019/3/22.
//
#import "p_inc.h"
#import <mach/mach_init.h>
#import <mach/vm_map.h>
#import <mach/mach_port.h>
#import <mach-o/dyld.h>
#include <mach-o/getsect.h>
#import "getU3dsystemfunc.h"
//F657 BDA9 F44F 01A9 FD7B 02A9 FD83 0091 FF43 01D1 F403 00AA FF7F 04A9 FF1F 00F9
int inputarray[] = {0xF657, 0xBDA9, 0xF44F, 0x01A9, 0xFD7B, 0x02A9, 0xFD83, 0x0091, 0xFF43, 0x01D1, 0xF403, 0x00AA, 0xFF7F, 0x04A9, 0xFF1F, 0x00F9};

static int biglittlecover(int x){
    //    short int x;
    unsigned char x0,x1;
    x0=((char*)&x)[0]; //低地址单元
    x1=((char*)&x)[1]; //高地址单元
    //    XLog(@"%x %x",x0,x1);
    return (x0<<8)+x1;
}

static bool cmpIndex(long nowaddr,int index,int * ary){
    if (index>11){
        XLog(@"%lx  %x %x",nowaddr,*(unsigned short*)(nowaddr+index*2),(unsigned short)*(ary+index));
    }
    return *(unsigned short*)(nowaddr+index*2)==(unsigned short)*(ary+index);
}

//FD7B BFA9 FD03 0091 E00B 0032 .... .... FD7B C1A8 c003 5fd6
long getU3dsystemfunc(long in_start,long in_end){
    XLog(@"\n------------getU3dsystemfunc--------------");
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
//    ushort a1 = MY_BUNDLE_S[0].paraAddr[ARRAY_START_TMN64]&0xffff;
//    ushort a2 = MY_BUNDLE_S[0].paraAddr[ARRAY_START_TMN64+1]&0xffff;
//    ushort a3 = MY_BUNDLE_S[0].paraAddr[ARRAY_START_TMN64+2]&0xffff;
//    ushort a4 = MY_BUNDLE_S[0].paraAddr[ARRAY_START_TMN64+3]&0xffff;
//    ushort a5 = MY_BUNDLE_S[0].paraAddr[ARRAY_START_TMN64+4]&0xffff;
//    ushort a6 = MY_BUNDLE_S[0].paraAddr[ARRAY_START_TMN64+5]&0xffff;
//    ushort a7 = MY_BUNDLE_S[0].paraAddr[ARRAY_START_TMN64+6]&0xffff;
//    ushort a8 = MY_BUNDLE_S[0].paraAddr[ARRAY_START_TMN64+7]&0xffff;
//    ushort a9 = MY_BUNDLE_S[0].paraAddr[ARRAY_START_TMN64+8]&0xffff;
//    ushort a10 = MY_BUNDLE_S[0].paraAddr[ARRAY_START_TMN64+9]&0xffff;
//    XLog(@"\tstart Searching timeManager in 64bit%x %x %x %x",a1,a2,a3,a4);
    XLog(@"\tnow 0x%lx-0x%lx idr %lx",now,end,idr);
    unsigned long len = sizeof(inputarray)/sizeof(int);
    int * bearray = (int*)malloc(sizeof(int)*len);
    for (int i=0;i<len;i++){
        XLog(@" 0x%x",biglittlecover(inputarray[i]));
        *(bearray+i)=biglittlecover(inputarray[i]);
    }
    while ((long)now<end-len*2){
        int index=0;
        while (1==cmpIndex(now, index,bearray)){
            index++;
//            XLog(@"getU3dsystemfunc step %d",index);
            if (index==len){
                XLog(@"check getU3dsystemfunc %lx",now-idr);
                temprev = now;
            }
        }
//        
//        if(*(short*)(now)==(short)inputarray[0])
//            if(*(short*)(now+2)==(short)inputarray[1])
//                if(*(short*)(now+4)==(short)inputarray[2])
//                    if(*(short*)(now+6)==(short)inputarray[3]){
//                        if(*(short*)(now+8)==(short)inputarray[4])
//                            if(*(short*)(now+10)==(short)inputarray[5])
//                                if(*(short*)(now+16)==(short)a7)
//                                    if(*(short*)(now+18)==(short)a8)
//                                        if(*(short*)(now+20)==(short)a9)
//                                            if(*(short*)(now+22)==(short)a10){
//                                                
//                                            }
//                    }
        now+=1;
    }
    if(temprev!=0){
        rev = temprev - idr;
        XLog(@"#######64 FOUND getU3dsystemfunc in %lx %lx",temprev,idr );
    }
    return rev;
}


/*
 
 */




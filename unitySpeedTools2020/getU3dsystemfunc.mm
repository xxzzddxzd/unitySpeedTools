//
//  getU3dsystemfunc.m
//  unitySpeedTools
//
//  Created by 徐正达 on 2019/3/22.
//  搜索Unity的System函数，用于直接控制变速函数。
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

    XLog(@"\tnow 0x%lx-0x%lx idr %lx",now,end,idr);
    unsigned long len = sizeof(inputarray)/sizeof(int);
    int * bearray = (int*)malloc(sizeof(int)*len);
    for (int i=0;i<len;i++){
//        XLog(@" 0x%x",biglittlecover(inputarray[i]));
        *(bearray+i)=biglittlecover(inputarray[i]);
    }
    while ((long)now<end-len*2){
        int index=0;
        while (1==cmpIndex(now, index,bearray)){
            index++;
            if (index==len){
//                XLog(@"check getU3dsystemfunc %lx",now-idr);
                temprev = now;
            }
        }

        now+=1;
    }
    if(temprev!=0){
        rev = temprev - idr;
        XLog(@"#######64 FOUND getU3dsystemfunc in %lx %lx",temprev,idr );
    }else{
        XLog(@"#######NOT FOUND getU3dsystemfunc" );
    }
    return rev;
}


/*
 
 */




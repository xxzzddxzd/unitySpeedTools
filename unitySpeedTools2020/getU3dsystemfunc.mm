#import "p_inc.h"
#import <mach/mach_init.h>
#import <mach/vm_map.h>
#import <mach/mach_port.h>
#import <mach-o/dyld.h>
#include <mach-o/getsect.h>
#import "getU3dsystemfunc.h"
#import <substrate.h>
long doLoadFramework();
static int biglittlecover(int x);
static bool cmpIndex(long nowaddr,int index,int * ary);
long searchintarget(long ad1,long ad2);
long searchintarget_new(long ad1, long ad2);

FILE *fopen(const char *filename, const char *mode){
    XLog(@"my fopen %s %s",filename,mode)
    return 0;
}


/* 应对Framework形式Unity*/
long doLoadFramework(){
    //    XLog(@"###############JBDETECT##################");
    fopen("1","wb");
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

//F657 BDA9 F44F 01A9 FD7B 02A9 FD83 0091 FF43 01D1 F403 00AA FF7F 04A9 FF1F 00F9

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
    vm_address_t region = (vm_address_t)dst;
    vm_size_t region_size = 0;
    
    vm_region_basic_info_data_64_t info;
    mach_msg_type_number_t info_count = VM_REGION_BASIC_INFO_COUNT_64;
    vm_region_flavor_t flavor = VM_REGION_BASIC_INFO_64;
    kern_return_t kr = mach_vm_region(mach_task_self(), &region, &region_size, flavor, (vm_region_info_t)&info, (mach_msg_type_number_t*)&info_count, (mach_port_t*)&task);
    if (kr != KERN_SUCCESS)
    {
        return 0;
    }
    
    *ad1 = region;
    *ad2 = region + region_size;
    
    if (info.protection < 1) {
        return 0;
    }
    XLog(@"getMap from %lx to %lx", region, region + region_size)
    return 64;
}
long dosearch() {
    // 分配两个 long 类型指针变量 ad1 和 ad2 的内存空间，大小均为一个 long 类型的字节大小。
    long *ad1 = (long*)malloc(sizeof(long));
    long *ad2 = (long*)malloc(sizeof(long));
    *ad2 = doLoadFramework();
    
    // 判断是否含有 il2cpp_resolve_icall_0 函数
    void *il2cpp_resolve_icall_0 = MSFindSymbol(0, "_il2cpp_resolve_icall");
    if (il2cpp_resolve_icall_0) {
        // il2cpp_resolve_icall 位置需要跳转的位置
        XLog(@"*(int*)il2cpp_resolve_icall_0 %lx %lx ", il2cpp_resolve_icall_0, *(long*)il2cpp_resolve_icall_0 & 0xff000000);
        
        // 往下查找第一个 0x14000000
        long baseaddr = (long)il2cpp_resolve_icall_0;
        for (int i = 0; i < 10; ++i) {
            long value = *(long*)baseaddr;
            if ((value & 0xff000000) == 0x14000000) {
                long bsr = ((value & 0xffffff) << 2); // 计算偏移
                long addrforil2cppresolveicall = baseaddr + bsr; // 加和
                XLog(@"il2cpp_resolve_icall_0 %lx", addrforil2cppresolveicall);
                return addrforil2cppresolveicall;
            }
            baseaddr += 4;
        }
    }
    
    // 未找到 il2cpp_resolve_icall_0 函数
    long rev = 0;
    while (getMap((void*)(*ad2), ad1, ad2) != 0) {
        //        rev = searchintarget(*ad1, *ad2);
        rev = searchintarget_new(*ad1, *ad2);
        if (rev != 0) {
            break;
        }
    }
    return rev;
}

long searchintarget1(long ad1, long ad2, int *target, unsigned long target_len) {
    long now = ad1;
    long end = ad2;
    long rev = 0;
    long temprev = 0;
    
    XLog(@"\tnow 0x%lx-0x%lx ", now, end);
    
    // 使用 target 数组进行查找（framework 类型）
    int *bearray = (int*)malloc(sizeof(int) * target_len);
    for (unsigned long i = 0; i < target_len; i++) {
        bearray[i] = biglittlecover(target[i]);
    }
    XLog(@"start for framework version");
    
    while (now < end - target_len * 2) {
        int index = 0;
        while (1 == cmpIndex(now, index, bearray)) {
            index++;
            if (index == target_len) {
                temprev = now;
                break;
            }
        }
        if (temprev != 0) {
            rev = temprev;
            XLog(@"FOUND in %lx ", temprev);
            free(bearray);
            return rev;
        }
        now += 1;
    }
    free(bearray);
    
    XLog(@"FOUND end");
    return rev;
}

long searchintarget_new(long ad1, long ad2) {
    // framework 类型的unity
    int framework_target[] = {0xFF03, 0x02D1, 0xF85F, 0x04A9, 0xF657, 0x05A9, 0xF44F, 0x06A9, 0xFD7B, 0x07A9, 0xFDC3, 0x0191, 0xF303, 0x00AA, 0xFFFF, 0x02A9, 0xFF13, 0x00F9};
    int framework_target1[] = {0xFFC3,0x01D1,0xF657,0x04A9,0xF44F,0x05A9,0xFD7B,0x06A9,0xFD83,0x0191,0xF303,0x00AA,0xE083,0x0091,0xE103,0x13AA,0x92FE,0xFF97};
    // 普通类型的unity
    int bin_target[] = {0xF657, 0xBDA9, 0xF44F, 0x01A9, 0xFD7B, 0x02A9, 0xFD83, 0x0091, 0xFF43, 0x01D1, 0xF403, 0x00AA, 0xFF7F, 0x04A9, 0xFF1F, 0x00F9};
    
    long result = searchintarget1(ad1, ad2, framework_target, sizeof(framework_target) / sizeof(int));
    if (result){
        XLog(@"framework_target get")
        return  result;
    }
    result = searchintarget1(ad1, ad2, framework_target1, sizeof(framework_target1) / sizeof(int));
    if (result){
        XLog(@"framework_target1 get")
        return  result;
    }
    result = searchintarget1(ad1, ad2, bin_target, sizeof(bin_target) / sizeof(int));
    if (result){
        XLog(@"bin_target get")
        return  result;
    }
    
    
}
long searchintarget(long ad1, long ad2) {
    // framework 类型的unity
    int target[] = {0xFF03, 0x02D1, 0xF85F, 0x04A9, 0xF657, 0x05A9, 0xF44F, 0x06A9, 0xFD7B, 0x07A9, 0xFDC3, 0x0191, 0xF303, 0x00AA, 0xFFFF, 0x02A9, 0xFF13, 0x00F9};
    // 普通类型的unity
    int target1[] = {0xF657, 0xBDA9, 0xF44F, 0x01A9, 0xFD7B, 0x02A9, 0xFD83, 0x0091, 0xFF43, 0x01D1, 0xF403, 0x00AA, 0xFF7F, 0x04A9, 0xFF1F, 0x00F9};
    
    long now = ad1;
    long end = ad2;
    long rev = 0;
    long temprev = 0;
    
    XLog(@"\tnow 0x%lx-0x%lx ", now, end);
    
    unsigned long len = sizeof(target) / sizeof(int);
    int *bearray = (int*)malloc(sizeof(int) * len);
    for (int i = 0; i < len; i++) {
        *(bearray + i) = biglittlecover(target[i]);
    }
    XLog(@"start for framework version");
    while (now < end - len * 2) {
        int index = 0;
        while (1 == cmpIndex(now, index, bearray)) {
            index++;
            if (index == len) {
                temprev = now;
            }
        }
        now += 1;
    }
    if (temprev != 0) {
        rev = temprev;
        XLog(@"FOUND  in %lx ", temprev);
        free(bearray);
        return rev;
    }
    
    XLog(@"start for normal version");
    now = ad1;
    end = ad2;
    rev = 0;
    temprev = 0;
    len = sizeof(target1) / sizeof(int);
    int *bearray1 = (int*)malloc(sizeof(int) * len);
    for (int i = 0; i < len; i++) {
        *(bearray1 + i) = biglittlecover(target1[i]);
    }
    while (now < end - len * 2) {
        int index = 0;
        while (1 == cmpIndex(now, index, bearray1)) {
            index++;
            if (index == len) {
                temprev = now;
            }
        }
        now += 1;
    }
    if (temprev != 0) {
        rev = temprev;
        XLog(@"FOUND  in %lx ", temprev);
    }
    else {
        XLog(@"FOUND end");
    }
    free(bearray);
    free(bearray1);
    return rev;
}
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
    }
    return *(unsigned short*)(nowaddr+index*2)==(unsigned short)*(ary+index);
}






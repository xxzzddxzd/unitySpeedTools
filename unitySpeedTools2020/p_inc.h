/*************This part need setting*************/
#define D_CODEPATH @"/Library/Preferences/com.apple.5kbps.unitySpeedTools.code.plist"
#define D_PREFPATH @"/var/mobile/Library/Preferences/unitySpeedToolsloader.plist"

/*********************end*************************/
#define log 1
#define mdebug log
#define mlog log
#define showlog log
#define dspeedup 1
#define TOTAL_MOD 17    //一共修改几处
#define TOTAL_MODIFY  TOTAL_MOD //一共几处修改（执行几次MSHookFunction）
#define TOTAL_VERSION 1 //一共几个版本
#define NEWOLD        1 //单版本或多版本 老的靠小  新的大

#define IN_MAC 0
#define ADD_INMAC "192.168.199.156"
#define VER_CLI 13
#define SRV_TEST 0

#if SRV_TEST
#define PORT_BY_VER 26800+666
#else
#define PORT_BY_VER 26800+VER_CLI
#endif
#define XLog(FORMAT, ...) NSLog(@"#pc %@" , [NSString stringWithFormat:FORMAT, ##__VA_ARGS__]);
#define psta XLog(@"%lx,%@",_dyld_get_image_vmaddr_slide(0),[NSThread callStackSymbols]);

@interface x5fP : NSObject
+ (void)ss1:(bool)isOn;
+ (void)ss2:(float)spValue;
+ (bool)gs1;
+ (float)gs2;
@end

enum ENGINE_STATE{
    SP_INIT_NIL,
    SP_INIT_WAIT,
    SP_INIT_DONE,
};

extern enum ENGINE_STATE gb_state;


enum SWTYPE{
    SW_NIL,
    SW_UNITY,
    SW_COCO2D,
};
typedef struct bundleid {
    NSString * pBundle;
    NSString * pExecName;
    NSString * pBundleNameCN;
    NSString * pBundleVer;
    int paraAddr[TOTAL_MODIFY];
}MY_BUNDLE;

extern MY_BUNDLE MY_BUNDLE_S[];

/*
 测试范本
 偶像大师：无timescale 32位/64位
 白猫：有timescale 32位/64位
 */

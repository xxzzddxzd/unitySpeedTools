#define D_PREFPATH @"/var/mobile/Library/Preferences/unitySpeedTools2020loader.plist"
#define XLog(FORMAT, ...) NSLog(@"#pc %@" , [NSString stringWithFormat:FORMAT, ##__VA_ARGS__]);
#define psta XLog(@"%lx,%@",_dyld_get_image_vmaddr_slide(0),[NSThread callStackSymbols]);

@interface x5fP : NSObject
+ (void)ss1:(bool)isOn;
+ (void)ss2:(float)spValue;
+ (bool)gs1;
+ (float)gs2;
@end

enum ENGINE_STATE{
    SP_INIT_NIL=0,
    SP_INIT_WAIT=1,
    SP_INIT_DONE=2,
    SP_INIT_PAUSE=3,
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
    int paraAddr[17];
}MY_BUNDLE;

extern MY_BUNDLE MY_BUNDLE_S[];


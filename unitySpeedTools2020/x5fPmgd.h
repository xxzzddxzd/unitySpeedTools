#ifndef XXModGlobalDefines_H_Hubert
#define XXModGlobalDefines_H_Hubert

// UI Settings
#define kMainScreenWidth    [UIScreen mainScreen].bounds.size.width
#define kMainScreenHeight   [UIScreen mainScreen].bounds.size.height

#define kModMainPanelWidth      250.0f
#define kModMainPanelHeight     150.0f

#define kSettingsCellLeftMarge      10.0f //Settings Cell 左边文字的边距
#define kSettingsCellSectionFont    15.0f //Settings Cell Section Header/Footer Font
#define kSettingsCellHeight     42.0f //Settings Cell Section Header/Footer Font

#define kSettingsCellAccessoryRightMarge    (([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending ) ? 30.0f : 40.0f)

#define kTextSectionHeader0   @" "
#define kTextRowTitle0N @""
#define kTextRowTitle00 @"开启变速"
#define kTextRowTitle01 @"速度倍数"


#define kTextAboutContent       @".. .."// 右上角感叹号里的文本内容

#define kTextNavTitle           @"通用游戏加速器"
#define kTextNavTitleAC         @"账号信息"
#define kTextHideMod            @" "
#define kTextOn                 @"打开"
#define kTextOff                @"关闭"
#define kTextNotAvailable       @"暂不可用稍后再试"
#define kTextSave               @"保存"
#define kTextCancel             @"取消"

#define kAlertNoticeTitleText   @" "
#define kAlertCancelText        @"取消"
#define kAlertHideText          @"隐藏"
#define kAlertHideContentText   @" "


#define cColorMainView [UIColor grayColor]


#endif

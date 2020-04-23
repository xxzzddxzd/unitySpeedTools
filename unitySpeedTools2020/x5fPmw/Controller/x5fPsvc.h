//
//  XXModController.h
//  MyTest
//
//  Created by 陈列奋 on 7/9/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "x5fPmbvc.h"

@class x5fPmco;

@protocol x5fPsd <NSObject> //XXSettingsDelegate

@optional

/**
 *  返回对应section的Header/Footer Title
 *
 *  @param section
 *
 *  @return 对应section的Header/Footer Title
 */
- (NSString *)titleForHeaderInSection:(NSInteger)section;
- (NSString *)titleForFooterInSection:(NSInteger)section;

/**
 *  自定义detail值的表现格式
 *  1、开关不需要处理
 *  2、输入框和滑动条（float），回转原值，格式需要自己转
 *  Example: "100倍" "100次"
 *
 *  @param value     输入框的返回输入值，滑动条的返回值是个float
 *  @param indexPath
 *
 *  @return 定义后的值
 */
- (NSString *)detailsStringWithFormat:(NSString *)value indexPath:(NSIndexPath *)indexPath;

/**
 *  用户设置后返回的值
 *
 *  @param value     返回值
 *  @param indexPath
 */
- (void)detailsValue:(x5fPmco *)value settingAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol x5fPsuicd <NSObject>   //XXSettingsUIControlDelegate

@optional

- (void)dismissSettingsViewControllerAction;
- (void)hideModeAction;

@end


@interface x5fPsvc : x5fPbvc   //XXSettingsViewController: XXModBaseViewController

@property (nonatomic, assign) id<x5fPsd> delegate;
@property (nonatomic, assign) id<x5fPsuicd> uiDelegate;

- (id)initWithCells:(NSArray *)cells;

@end

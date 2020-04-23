//
//  XXModCellObject.h
//  MyTest
//
//  Created by 陈列奋 on 7/9/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    CellSelectTypeSwitch      = 0,
    CellSelectTypeTextField   = 1,
    CellSelectTypeSlider = 2,
    CellSelectTypeNone,
}CellSelectType;

@interface x5fPmco : NSObject

@property (nonatomic, retain) NSString *title;
@property (nonatomic, assign) CellSelectType inputType;

// Toggle
@property (nonatomic, assign) BOOL toggleValue;

// Input TextField
@property (nonatomic, assign) NSInteger inputValue;
@property (nonatomic, assign) NSInteger inputDefaultValue; // Default值时显示灰色，其余显示绿色

// UISlider
@property (nonatomic, assign) float sliderMinimumValue;
@property (nonatomic, assign) float sliderMaximumValue;
@property (nonatomic, assign) float sliderValue;
@property (nonatomic, assign) float sliderDefaultValue; // Default值时显示灰色，其余显示绿色


- (id)initWithTitle:(NSString *)title withInputType:(CellSelectType)type;

- (id)initSwitchTypeWithTitle:(NSString *)title toggle:(BOOL)toggleValue;   // 开关
- (id)initInputTypeWithTitle:(NSString *)title value:(NSInteger)value defaultValue:(NSInteger)defaultValue;    // 输入框
- (id)initSliderTypeWithTitle:(NSString *)title value:(float)value defaultValue:(float)defaultValue minValue:(float)min maxValue:(float)max;   // 滑动条

@end
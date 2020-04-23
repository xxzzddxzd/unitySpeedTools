//
//  XXModCellObject.m
//  MyTest
//
//  Created by 陈列奋 on 7/9/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import "x5fPmco.h"

@implementation x5fPmco

- (id)initWithTitle:(NSString *)title withInputType:(CellSelectType)type
{
    self = [super init];
    if (self) {
        self.title = title;
        self.inputType = type;
    }
    return self;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        self.title = @"Default";
        self.inputType = CellSelectTypeSwitch;
    }
    return self;
}

- (id)initSwitchTypeWithTitle:(NSString *)title toggle:(BOOL)toggleValue
{
    self = [super init];
    
    if (self) {
        self.title = title;
        self.inputType = CellSelectTypeSwitch;
        self.toggleValue = toggleValue;
    }
    return self;
}

- (id)initInputTypeWithTitle:(NSString *)title value:(NSInteger)value defaultValue:(NSInteger)defaultValue
{
    self = [super init];
    
    if (self) {
        self.title = title;
        self.inputType = CellSelectTypeTextField;
        self.inputValue = value;
        self.inputDefaultValue = defaultValue;
    }
    return self;
}

- (id)initSliderTypeWithTitle:(NSString *)title value:(float)value defaultValue:(float)defaultValue minValue:(float)min maxValue:(float)max
{
    self = [super init];
    
    if (self) {
        self.title = title;
        self.inputType = CellSelectTypeSlider;
        self.sliderValue = value;
        self.sliderDefaultValue = defaultValue;
        self.sliderMinimumValue = min;
        self.sliderMaximumValue = max;
    }
    return self;
}


@end

//
//  XXModController.m
//  MyTest
//
//  Created by 陈列奋 on 7/9/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import "x5fPsvc.h"
#import "x5fPavc.h"
#import "x5fPmgd.h"
#import "x5fPmco.h"
#import "x5fPav.h"
#import "x5fPsc.h"
#import <QuartzCore/QuartzCore.h>

#define kTagAlertSliderView     100000
#define kTagAlertTextFieldView  200000

#define kTagAlertSlider         300000
#define kTagAlertSliderLabel    400000
#define kTagAlertTextField      500000

//extern bool gotAddr;

@interface x5fPsvc()
<
x5fPavd,  //XXAlertViewDelegate
UIAlertViewDelegate,
UITableViewDataSource,
UITableViewDelegate,
UITextFieldDelegate
>
@property (nonatomic, retain) NSArray *dataSource;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSIndexPath *currentSelectIndexPath;
@property (nonatomic, retain) NSMutableArray *tableSectionHeaderHeight;
@property (nonatomic, retain) NSMutableArray *tableSectionFooterHeight;
@end

@implementation x5fPsvc

#pragma mark - viewcontroller
- (id)initWithCells:(NSArray *)cells
{
    self = [super init];
    if (self) {
        self.dataSource = cells;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)initView
{
    [super initView];
#if 0
    UIButton *btnInfo = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnInfo setTitle:@"账号" forState:UIControlStateNormal];
    [btnInfo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btnInfo setImage:[self infoButtonBGImage] forState:UIControlStateNormal];
    btnInfo.frame = CGRectMake(CGRectGetWidth(self.customNavBar.frame) - 45, 0, 45, 41);
    [btnInfo addTarget:self action:@selector(customNavigationBarRightItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.customNavBar addSubview:btnInfo];
#endif
    self.tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.customNavBar.frame), kModMainPanelWidth, kModMainPanelHeight - CGRectGetHeight(self.customNavBar.frame)) style:UITableViewStyleGrouped] autorelease];
    self.tableView.backgroundColor = cColorMainView;  //设置栏主框体颜色
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundView = nil;
    self.tableView.tableHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 1.0f)] autorelease];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        self.tableView.separatorInset = UIEdgeInsetsMake(0, kSettingsCellLeftMarge, 0, kSettingsCellLeftMarge);
    }
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];

    // Table Footer View
    UIView *customFooterView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 40)] autorelease];
    customFooterView.backgroundColor = cColorMainView;
    self.tableView.tableFooterView = customFooterView;
    
    UIButton *btnHide = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnHide setTitle:kTextHideMod forState:UIControlStateNormal];
    [btnHide setTitleColor:[self colorWithHexValue:0xfe0000 alpha:1] forState:UIControlStateNormal];
    btnHide.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [btnHide sizeToFit];
    btnHide.frame = CGRectMake((CGRectGetWidth(customFooterView.frame) - CGRectGetWidth(btnHide.frame)) / 2.0f,
                               (CGRectGetHeight(customFooterView.frame) - CGRectGetHeight(btnHide.frame)) / 2.0f,
                               CGRectGetWidth(btnHide.frame),
                               CGRectGetHeight(btnHide.frame));
    [btnHide addTarget:self action:@selector(hideModButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [customFooterView addSubview:btnHide];
    
    self.tableSectionHeaderHeight = @[].mutableCopy;
    self.tableSectionFooterHeight = @[].mutableCopy;
    
    // Section Header / Footer Height
    for (int i = 0; i < self.dataSource.count; i++) {
        CGFloat height = i == 0 ? 8 : 1;
        if ([self.delegate respondsToSelector:@selector(titleForHeaderInSection:)]) {
            NSString *header = [self.delegate titleForHeaderInSection:i];
            if (header && ![header isEqualToString:@""]) {
                height = [self heightForText:header font:[UIFont systemFontOfSize:14] constraintWidth:(kModMainPanelWidth - kSettingsCellLeftMarge*2)];
                height = height + 14.0f;
            }
        }
        [self.tableSectionHeaderHeight addObject:[NSNumber numberWithFloat:height]];
    }

    for (int i = 0; i < self.dataSource.count; i++) {
        CGFloat height = 8;
        if ([self.delegate respondsToSelector:@selector(titleForFooterInSection:)]) {
            NSString *footer = [self.delegate titleForFooterInSection:i];
            if (footer && ![footer isEqualToString:@""]) {
                height = [self heightForText:footer font:[UIFont systemFontOfSize:14] constraintWidth:(kModMainPanelWidth - kSettingsCellLeftMarge*2)];
                height = height + 14.0f;
            }
        }
        [self.tableSectionFooterHeight addObject:[NSNumber numberWithFloat:height]];
    }
}


#pragma mark - Helper

- (NSString *)configuredDetailsStringWithDelegateFormat:(NSString *)detailText indexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(detailsStringWithFormat:indexPath:)]) {
        NSString *tempText = [self.delegate detailsStringWithFormat:detailText indexPath:indexPath];
        if (tempText && ![tempText isEqualToString:@""]) {
            detailText = tempText;
        }
    }
    return detailText;
}

#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.dataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.dataSource objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *bundleID = @"XModCell";
    x5fPsc *cell = [tableView dequeueReusableCellWithIdentifier:bundleID];
    if (cell == nil) {
        cell = [[x5fPsc alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:bundleID];
    }
    
    x5fPmco *object = (x5fPmco *)[[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    if (object.inputType == CellSelectTypeSwitch) {
//        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.customAccessoryView.hidden = YES;
//        if (!gotAddr) {
//            [cell configuredCellWithLeftText:object.title rightText:kTextNotAvailable isDefault:!object.toggleValue];
//        }
//        else
            if (object.toggleValue) {
            [cell configuredCellWithLeftText:object.title rightText:kTextOn isDefault:!object.toggleValue];
        }
        else {
            [cell configuredCellWithLeftText:object.title rightText:kTextOff isDefault:!object.toggleValue];
        }
    }
    else if(object.inputType == CellSelectTypeTextField){
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.customAccessoryView.hidden = NO;
        NSString *detailText = [self configuredDetailsStringWithDelegateFormat:[NSString stringWithFormat:@"%d",object.inputValue] indexPath:indexPath];
        BOOL isDefault = (object.inputDefaultValue == [detailText integerValue]);
        [cell configuredCellWithLeftText:object.title rightText:detailText isDefault:isDefault];
    }
    else if(object.inputType == CellSelectTypeSlider){
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.customAccessoryView.hidden = NO;
        NSString *detailText = [self configuredDetailsStringWithDelegateFormat:[NSString stringWithFormat:@"%f",object.sliderValue] indexPath:indexPath];
        BOOL isDefault = (object.sliderDefaultValue == [detailText integerValue]);
        [cell configuredCellWithLeftText:object.title rightText:detailText isDefault:isDefault];
    }
    
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kSettingsCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [_tableSectionHeaderHeight[section] floatValue];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return [_tableSectionFooterHeight[section] floatValue];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, kModMainPanelWidth, [_tableSectionHeaderHeight[section] floatValue])] autorelease];
    header.backgroundColor = cColorMainView;

    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(kSettingsCellLeftMarge, CGRectGetHeight(header.frame) - 1.0f, kModMainPanelWidth - kSettingsCellLeftMarge*2, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3f].CGColor;
    
    [header.layer addSublayer:bottomBorder];

    if ([self.delegate respondsToSelector:@selector(titleForHeaderInSection:)]) {
        NSString *title = [self.delegate titleForHeaderInSection:section];
        if (title && ![title isEqualToString:@""]) {
            UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(kSettingsCellLeftMarge, 0, kModMainPanelWidth - kSettingsCellLeftMarge*2, CGRectGetHeight(header.frame))] autorelease];
            label.textColor = [self colorWithHexValue:0xbfbfbf alpha:1];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:14];
            label.numberOfLines = 0;
            label.text = title;
            
            [header addSubview:label];
            return header;
        }
    }
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, kModMainPanelWidth, [_tableSectionFooterHeight[section] floatValue])] autorelease];
    footer.backgroundColor = [UIColor clearColor];

    if ([self.delegate respondsToSelector:@selector(titleForFooterInSection:)]) {
        NSString *title = [self.delegate titleForFooterInSection:section];
        if (title && ![title isEqualToString:@""]) {
            
            UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(kSettingsCellLeftMarge, 0, kModMainPanelWidth - kSettingsCellLeftMarge*2, CGRectGetHeight(footer.frame))] autorelease];
            label.textColor = [self colorWithHexValue:0xbfbfbf alpha:1];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:14];
            label.text = title;
            label.numberOfLines = 0;

            [footer addSubview:label];
            return footer;
        }
    }
    return footer;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.currentSelectIndexPath = indexPath;
    x5fPmco *object = (x5fPmco *)[[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (object.inputType == CellSelectTypeSwitch) {
        //更改设置
//        if (!gotAddr) {
//
//        }
//        else{
            object.toggleValue = !object.toggleValue;
//        }
        [self.delegate detailsValue:object settingAtIndexPath:indexPath];
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    else if (object.inputType == CellSelectTypeSlider){
        //弹出选择通知框
//        if (!gotAddr) {
//            
//        }
//        else{
            [self showInputSliderForSection:indexPath.section forRow:indexPath.row];
//        }
    }
    else if (object.inputType == CellSelectTypeTextField){
        //弹出输入通知框
        [self showInputTextFieldForSection:indexPath.section forRow:indexPath.row];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}

#pragma mark - AlertView delegate

- (void)x5fPav:(x5fPav *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        if (alertView.tag == kTagAlertTextFieldView) {
            // TextInput
            NSString *value = ((UITextField *)[alertView viewWithTag:kTagAlertTextField]).text;
            if (!value || [value isEqualToString:@""]) {
                return;
            }
            x5fPmco *object = (x5fPmco *)[[self.dataSource objectAtIndex:_currentSelectIndexPath.section] objectAtIndex:_currentSelectIndexPath.row];
            object.inputValue = [value integerValue];
            [self.delegate detailsValue:object settingAtIndexPath:_currentSelectIndexPath];
            
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:_currentSelectIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
        else if (alertView.tag == kTagAlertSliderView) {
            // Slider
            float value = ((UISlider *)[alertView viewWithTag:kTagAlertSlider]).value;
            x5fPmco *object = (x5fPmco *)[[self.dataSource objectAtIndex:_currentSelectIndexPath.section] objectAtIndex:_currentSelectIndexPath.row];
            object.sliderValue = value;
            [self.delegate detailsValue:object settingAtIndexPath:_currentSelectIndexPath];
            
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:_currentSelectIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        if ([self.uiDelegate respondsToSelector:@selector(hideModeAction)]) {
            [self.uiDelegate hideModeAction];
        }
    }
}

#pragma mark - Action Handler

- (void)showInputTextFieldForSection:(NSInteger)section forRow:(NSInteger)row
{
    x5fPmco *object = (x5fPmco *)[[self.dataSource objectAtIndex:section] objectAtIndex:row];
    x5fPav *alertView = [[x5fPav alloc] initWithTitle:object.title message:@"\n\n" delegate:self cancelButtonTitle:kTextCancel otherButtonTitles:kTextSave, nil];
    alertView.tag = kTagAlertTextFieldView;
    
    UITextField *textField = [[[UITextField alloc] initWithFrame:CGRectMake(30, 65, 200, 30)] autorelease];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.delegate = self;
    textField.font = [UIFont systemFontOfSize:15];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.tag = kTagAlertTextField;
    [alertView addSubview:textField];
    
    alertView.frame = CGRectOffset(alertView.frame, 0, -kOffsetYWhenSubViewIsTextField);

    [alertView show];
    [alertView release];
}

- (void)showInputSliderForSection:(NSInteger)section forRow:(NSInteger)row
{
    x5fPmco *object = (x5fPmco *)[[self.dataSource objectAtIndex:section] objectAtIndex:row];
    x5fPav *alertView = [[x5fPav alloc] initWithTitle:object.title message:@"\n\n" delegate:self cancelButtonTitle:kTextCancel otherButtonTitles:kTextSave, nil];
    alertView.tag = kTagAlertSliderView;
    
    UISlider *slider = [[[UISlider alloc] initWithFrame:CGRectMake(30, 70, 200, 20)] autorelease];
    slider.minimumValue = object.sliderMinimumValue;
    slider.maximumValue = object.sliderMaximumValue;
    slider.value = object.sliderValue;
    [slider addTarget:self action:@selector(sliderUpdateValueAction:) forControlEvents:UIControlEventValueChanged];
    [alertView addSubview:slider];
    slider.tag = kTagAlertSlider;
    
    UILabel *sliderValueLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    sliderValueLabel.backgroundColor = [UIColor clearColor];
    sliderValueLabel.textAlignment = NSTextAlignmentRight;
    sliderValueLabel.font = [UIFont systemFontOfSize:15.0f];
    sliderValueLabel.tag = kTagAlertSliderLabel;
    sliderValueLabel.textColor = kAlertViewButtonTitleColorNormal;
    sliderValueLabel.text = [self configuredDetailsStringWithDelegateFormat:[NSString stringWithFormat:@"%f",object.sliderValue]
                                                                  indexPath:[NSIndexPath indexPathForRow:row inSection:section]];
    [sliderValueLabel sizeToFit];
    sliderValueLabel.frame = CGRectMake(CGRectGetMinX(slider.frame),
                                        CGRectGetMinY(slider.frame) - CGRectGetHeight(sliderValueLabel.frame) - 4.0f,
                                        CGRectGetWidth(slider.frame), CGRectGetHeight(sliderValueLabel.frame));
    [alertView addSubview:sliderValueLabel];
    [alertView show];
    [alertView release];
}

- (void)sliderUpdateValueAction:(UISlider *)sender
{
    x5fPav *alertView = (x5fPav *)sender.superview;
    UILabel *sliderValueLabel = (UILabel *)[alertView viewWithTag:kTagAlertSliderLabel];
    sliderValueLabel.text = [self configuredDetailsStringWithDelegateFormat:[NSString stringWithFormat:@"%f",sender.value]
                                                                  indexPath:_currentSelectIndexPath];
}

- (void)customNavigationBarLeftItemAction:(UIButton *)button
{
    if ([self.uiDelegate respondsToSelector:@selector(dismissSettingsViewControllerAction)]) {
        [self.uiDelegate dismissSettingsViewControllerAction];
    }
}

- (void)customNavigationBarRightItemAction:(UIButton *)button
{
    x5fPavc *aboutVC = [[x5fPavc alloc] init];
    [self.navigationController pushViewController:aboutVC animated:YES];
}

- (void)hideModButtonAction:(UIButton *)button
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kAlertNoticeTitleText
                                                        message:kAlertHideContentText
                                                       delegate:self
                                              cancelButtonTitle:kAlertCancelText
                                              otherButtonTitles:kAlertHideText, nil];
    [alertView show];
    [alertView release];
}

- (BOOL)prefersStatusBarHidden
{
//    NSLog(@"********HIDDEN svc*********");
    return YES; //返回NO表示要显示，返回YES将hiden
}

@end

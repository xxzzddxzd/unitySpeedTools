//
//  XXSettingsCell.h
//  XXModWidgetExample
//
//  Created by Hubert on 14-7-10.
//  Copyright (c) 2014年 Hubert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface x5fPsc : UITableViewCell

@property (nonatomic, retain) UIImageView *customAccessoryView;

- (void)configuredCellWithLeftText:(NSString *)left rightText:(NSString *)right isDefault:(BOOL)isDefault;

@end

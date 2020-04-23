//
//  XXSettingsCell.m
//  XXModWidgetExample
//
//  Created by Hubert on 14-7-10.
//  Copyright (c) 2014年 Hubert. All rights reserved.
//

#import "x5fPsc.h"
#import "x5fPmgd.h"

@interface x5fPsc () //XXSettingsCell

@property (nonatomic, retain) UILabel *leftLabel;
@property (nonatomic, retain) UILabel *rightLabel;

@end

@implementation x5fPsc

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSettingsCellLeftMarge, 11.0f, 0, 0)];
        self.leftLabel.backgroundColor = [UIColor clearColor];
        self.leftLabel.font = [UIFont systemFontOfSize:16.0f];
        self.leftLabel.textColor = [UIColor whiteColor];
        self.leftLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.8];
        self.leftLabel.shadowOffset = CGSizeMake(1, -1);
        [self addSubview:self.leftLabel];
        
        self.rightLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.rightLabel.backgroundColor = [UIColor clearColor];
        self.rightLabel.textAlignment = NSTextAlignmentRight;
        self.rightLabel.font = [UIFont systemFontOfSize:15.0f];
        self.rightLabel.textColor = [self colorWithHexValue:0xbfbfbf alpha:1];
        [self addSubview:self.rightLabel];
        
        UIView *backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        backgroundView.backgroundColor = [UIColor clearColor];
        backgroundView.clipsToBounds = YES;
        backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.backgroundView = backgroundView;
        [backgroundView release];
        
        UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
        selectedBackgroundView.backgroundColor = [UIColor grayColor];
        selectedBackgroundView.clipsToBounds = YES;
        selectedBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.selectedBackgroundView = selectedBackgroundView;
        [selectedBackgroundView release];
        
        self.customAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(kModMainPanelWidth - kSettingsCellAccessoryRightMarge + 6, (kSettingsCellHeight - 13.0) / 2.0, 8.0, 13.0)];
        self.customAccessoryView.image = [self customAccessoryViewNormalImage];
        self.customAccessoryView.highlightedImage = [self customAccessoryViewHighlightedImage];
        [self.contentView addSubview:self.customAccessoryView];

        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(kSettingsCellLeftMarge, kSettingsCellHeight - 1.0f, kModMainPanelWidth - kSettingsCellLeftMarge * 2, 1.0f);
//        bottomBorder.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3f].CGColor;

        [self.layer addSublayer:bottomBorder];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configuredCellWithLeftText:(NSString *)left rightText:(NSString *)right isDefault:(BOOL)isDefault
{
    self.rightLabel.text = right;
    [self.rightLabel sizeToFit];

    if ([self.customAccessoryView isHidden]) {
        self.rightLabel.frame = CGRectMake(kModMainPanelWidth - CGRectGetWidth(self.rightLabel.frame) - kSettingsCellAccessoryRightMarge + 12.0f,
                                           (kSettingsCellHeight - CGRectGetHeight(self.rightLabel.frame)) / 2.0f,
                                           CGRectGetWidth(self.rightLabel.frame), CGRectGetHeight(self.rightLabel.frame));
    }
    else {
        self.rightLabel.frame = CGRectMake(kModMainPanelWidth - CGRectGetWidth(self.rightLabel.frame) - kSettingsCellAccessoryRightMarge,
                                           (kSettingsCellHeight - CGRectGetHeight(self.rightLabel.frame)) / 2.0f,
                                           CGRectGetWidth(self.rightLabel.frame), CGRectGetHeight(self.rightLabel.frame));
    }

    self.leftLabel.text = left;
    [self.leftLabel sizeToFit];
    
    if ((CGRectGetMaxX(self.leftLabel.frame) +10.0f) > CGRectGetMinX(self.rightLabel.frame)) {
        self.leftLabel.frame = CGRectMake(CGRectGetMinX(self.leftLabel.frame), CGRectGetMinY(self.leftLabel.frame), CGRectGetMinX(self.rightLabel.frame) - CGRectGetMinX(self.leftLabel.frame)*2, CGRectGetHeight(self.leftLabel.frame));
    }
    
    if (isDefault) {
        self.rightLabel.textColor = [self colorWithHexValue:0xbfbfbf alpha:1];
    }
    else {
        self.rightLabel.textColor = [self colorWithHexValue:0x00ff01 alpha:1];
    }
}

- (UIColor *)colorWithHexValue:(NSUInteger)hexValue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((hexValue >> 16) & 0x000000FF)/255.0f
                           green:((hexValue >> 8) & 0x000000FF)/255.0f
                            blue:((hexValue) & 0x000000FF)/255.0
                           alpha:alpha];
}

- (UIImage *)customAccessoryViewNormalImage
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(8,13), NO, 0);
    
    //// Color Declarations
    UIColor* color2 = [UIColor colorWithRed: 0.718 green: 0.718 blue: 0.718 alpha: 1];
    
    //// Bezier Drawing
    UIBezierPath* bezierPath = UIBezierPath.bezierPath;
    [bezierPath moveToPoint: CGPointMake(1.45, 0)];
    [bezierPath addLineToPoint: CGPointMake(8, 6.5)];
    [bezierPath addLineToPoint: CGPointMake(1.45, 13)];
    [bezierPath addLineToPoint: CGPointMake(0, 11.63)];
    [bezierPath addLineToPoint: CGPointMake(5.09, 6.5)];
    [bezierPath addLineToPoint: CGPointMake(0, 1.37)];
    [bezierPath addLineToPoint: CGPointMake(1.45, 0)];
    [bezierPath closePath];
    [color2 setFill];
    [bezierPath fill];
    
    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return im;
}

- (UIImage *)customAccessoryViewHighlightedImage
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(8,13), NO, 0);

    //// Color Declarations
    UIColor* color2 = [UIColor colorWithRed: 0.962 green: 0.962 blue: 0.962 alpha: 1];
    
    //// Bezier Drawing
    UIBezierPath* bezierPath = UIBezierPath.bezierPath;
    [bezierPath moveToPoint: CGPointMake(1.45, 0)];
    [bezierPath addLineToPoint: CGPointMake(8, 6.5)];
    [bezierPath addLineToPoint: CGPointMake(1.45, 13)];
    [bezierPath addLineToPoint: CGPointMake(0, 11.63)];
    [bezierPath addLineToPoint: CGPointMake(5.09, 6.5)];
    [bezierPath addLineToPoint: CGPointMake(0, 1.37)];
    [bezierPath addLineToPoint: CGPointMake(1.45, 0)];
    [bezierPath closePath];
    [color2 setFill];
    [bezierPath fill];

    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return im;
}

@end

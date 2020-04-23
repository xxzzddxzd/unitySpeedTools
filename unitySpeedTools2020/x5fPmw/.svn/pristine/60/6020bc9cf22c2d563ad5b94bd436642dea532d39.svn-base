//
//  HBView.m
//  HBDanMu
//
//  Created by Hubert on 14-4-30.
//  Copyright (c) 2014年 Hubert. All rights reserved.
//

#import "HBView.h"

@implementation HBView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    id hitView = [super hitTest:point withEvent:event];
    if (hitView == self) {
        return nil;
    }
    else {
        return hitView;
    }
}

@end

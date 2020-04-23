//
//  XXModCenter.h
//  XXModUIExample
//
//  Created by Hubert on 14-7-10.
//  Copyright (c) 2014年 Hubert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "p_inc.h"
@interface x5fPmc : NSObject //XXModCenter
{
    int p1;
    int p2;
}
+ (x5fPmc *)defaultCenter;
+ (void)showIcon;
+ (void)hiddenIcon;
@end

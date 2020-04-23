//
//  XXAlertViewManager.h
//  XXSecure
//
//  Created by Kloudz Liang on 13-5-31.
//  Copyright (c) 2013年 XX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class x5fPav;

@interface x5fPavm : NSObject //XXAlertViewManager
{
    UIWindow        *_lastKeyWindow;
    NSMutableArray  *_displayQueue;
    x5fPav    *_currentAlertView;
    id               _delegateOfCurrentAlertView;
}

+ (x5fPavm *)shareAlertViewManager;

- (void)showAlertView:(x5fPav *)alertView;
- (void)alertViewDidDismiss:(x5fPav *)alertView;

@end

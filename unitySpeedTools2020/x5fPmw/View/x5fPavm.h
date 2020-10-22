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

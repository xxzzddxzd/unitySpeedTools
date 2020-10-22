#import "x5fPavm.h"
#import "x5fPav.h"

@interface x5fPavm ()
@property(nonatomic,retain) UIWindow *lastKeyWindow;
@property(nonatomic,retain) x5fPav *currentAlertView;
@property(nonatomic,retain) id delegateOfCurrentAlertView;  // 备份alertView的delegate，防止autoDismissWhenEnterBackground时delegate被清空导致crash的情况
@end

@implementation x5fPavm

@synthesize lastKeyWindow = _lastKeyWindow;
@synthesize currentAlertView = _currentAlertView;
@synthesize delegateOfCurrentAlertView = _delegateOfCurrentAlertView;

+ (x5fPavm *)shareAlertViewManager
{
    static x5fPavm *sharedAlertViewManager = nil;
    @synchronized(self) {
        if (sharedAlertViewManager == nil) {
            sharedAlertViewManager = [[x5fPavm alloc] init];
        }
    }
    return sharedAlertViewManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        _displayQueue = [[NSMutableArray alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    self.lastKeyWindow = nil;
    self.currentAlertView = nil;
    self.delegateOfCurrentAlertView = nil;
    [_displayQueue release];
    _displayQueue = nil;
    
    [super dealloc];
}

- (void)applicationDidEnterBackground:(NSNotification *)notification
{
    @synchronized(_displayQueue) {
        // 把队列里要autoDismissWhenEnteringBackground的都移除
        NSMutableArray *alertViewsShouldBeRemoved = [[NSMutableArray alloc] init];
        for (x5fPav *alertView in _displayQueue) {
            if (alertView.autoDismissWhenEnteringBackground) {
                alertView.delegate = nil;
                [alertViewsShouldBeRemoved addObject:alertView];
            }
        }
        [_displayQueue removeObjectsInArray:alertViewsShouldBeRemoved];
        [alertViewsShouldBeRemoved release];
    }
    
    if (self.currentAlertView && self.currentAlertView.autoDismissWhenEnteringBackground) {
        [self.currentAlertView clearDelegateAndDismiss];
    }
}

#pragma mark -

- (void)firstAlertViewWillShow
{
    self.lastKeyWindow = [UIApplication sharedApplication].keyWindow;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidBecomeKey:) name:UIWindowDidBecomeKeyNotification object:nil];
}

- (void)lastAlertViewWillDismiss
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIWindowDidBecomeKeyNotification object:nil];
    if (self.lastKeyWindow) {
        [self.lastKeyWindow makeKeyWindow];
        self.lastKeyWindow = nil;
    } else {
        id delegate = [UIApplication sharedApplication].delegate;
        if ([delegate respondsToSelector:@selector(window)]) {
            UIWindow *mainWindow = [delegate performSelector:@selector(window)];
            [mainWindow makeKeyWindow];
        }
    }
    self.currentAlertView = nil;
    self.delegateOfCurrentAlertView = nil;
}

- (void)windowDidBecomeKey:(NSNotification *)notification
{
    UIWindow *nKeyWindow = notification.object;
    UIWindow *windowOfCurrentAlertView = nil;
    if ([self.currentAlertView respondsToSelector:@selector(dimWindow)]) {
        windowOfCurrentAlertView = [self.currentAlertView performSelector:@selector(dimWindow)];
    }
    if (windowOfCurrentAlertView && nKeyWindow != windowOfCurrentAlertView) {
        if (nKeyWindow.windowLevel <= windowOfCurrentAlertView.windowLevel) {
            self.lastKeyWindow = nKeyWindow;
            [windowOfCurrentAlertView makeKeyWindow];
        }
    }
}

#pragma mark -

- (void)showAlertView:(x5fPav *)alertView
{
    @synchronized(_displayQueue) {
        if (alertView) {
            if ([_displayQueue count] == 0) {
                [self firstAlertViewWillShow];
                [_displayQueue addObject:alertView];
                
                self.currentAlertView = alertView;
                if (alertView.autoDismissWhenEnteringBackground) {
                    self.delegateOfCurrentAlertView = alertView.delegate;
                } else {
                    self.delegateOfCurrentAlertView = nil;
                }
                [self.currentAlertView showImmediately];
            } else if (![_displayQueue containsObject:alertView]) {
                [_displayQueue addObject:alertView];
            }
        }
        
    }
}

- (void)alertViewDidDismiss:(x5fPav *)alertView
{
    @synchronized(_displayQueue) {
        if (alertView) {
            [_displayQueue removeObject:alertView];
        }
        if ([_displayQueue count] > 0) {
            x5fPav *nextAlertView = [_displayQueue objectAtIndex:0];
            
            self.currentAlertView = nextAlertView;
            if (alertView.autoDismissWhenEnteringBackground) {
                self.delegateOfCurrentAlertView = alertView.delegate;
            } else {
                self.delegateOfCurrentAlertView = nil;
            }
            [self.currentAlertView showImmediately];
        } else {
            [self lastAlertViewWillDismiss];
        }
    }
}

@end

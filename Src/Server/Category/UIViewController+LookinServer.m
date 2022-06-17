//
//  UIViewController+LookinServer.m
//  LookinServer
//
//  Created by Li Kai on 2019/4/22.
//  https://lookin.work
//

#import "UIViewController+LookinServer.h"
#import "UIView+LookinServer.h"
#import <objc/runtime.h>

@implementation UIViewController (LookinServer)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method oriMethod = class_getInstanceMethod([UIViewController class], @selector(setView:));
        Method newMethod = class_getInstanceMethod([UIViewController class], @selector(lks_setView:));
        method_exchangeImplementations(oriMethod, newMethod);
    });
}

- (void)lks_setView:(UIView*)view {
    [self lks_setView:view];
    self.view.lks_hostViewController = self;
}

+ (nullable UIViewController *)lks_visibleViewController {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *visibleViewController = [rootViewController lks_visibleViewControllerIfExist];
    return visibleViewController;
}

- (UIViewController *)lks_visibleViewControllerIfExist {
    
    if (self.presentedViewController) {
        return [self.presentedViewController lks_visibleViewControllerIfExist];
    }
    
    if ([self isKindOfClass:[UINavigationController class]]) {
        return [((UINavigationController *)self).visibleViewController lks_visibleViewControllerIfExist];
    }
    
    if ([self isKindOfClass:[UITabBarController class]]) {
        return [((UITabBarController *)self).selectedViewController lks_visibleViewControllerIfExist];
    }
    
    if (self.isViewLoaded && !self.view.hidden && self.view.alpha > 0.01) {
        return self;
    } else {
        return nil;
    }
}

@end

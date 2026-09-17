#import <UIKit/UIKit.h>

static void processAntiBurn(UIView *view) {
    if (view.hidden) return;
    
    NSString *className = NSStringFromClass([view class]);
    
    // Таргетируем центральную кнопку "+" и остальные кнопки нижней панели
    BOOL isBottomButton = [className isEqualToString:@"AWETabBarPlusButton"] || 
                          [className isEqualToString:@"TTKTabBarButton"];
    
    if (isBottomButton) {
        if (view.alpha > 0.01) {
            view.alpha = 0.01; // 100% визуальная прозрачность с сохранением тапов
        }
        return;
    }
    
    for (UIView *subview in view.subviews) {
        processAntiBurn(subview);
    }
}

__attribute__((constructor))
static void init_antiburn(void) {
    [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSSet *connectedScenes = [UIApplication sharedApplication].connectedScenes;
            for (UIScene *scene in connectedScenes) {
                if ([scene isKindOfClass:[UIWindowScene class]]) {
                    UIWindowScene *windowScene = (UIWindowScene *)scene;
                    for (UIWindow *window in windowScene.windows) {
                        if (window.isKeyWindow) {
                            processAntiBurn(window);
                        }
                    }
                }
            }
        });
    }];
}

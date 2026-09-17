#import <UIKit/UIKit.h>

static void processAntiBurn(UIView *view) {
    if (view.hidden || view.alpha == 0.0) return;
    
    NSString *className = NSStringFromClass([view class]);
    
    // Ищем только центральную кнопку плюса
    if ([className isEqualToString:@"AWETabBarPlusButton"]) {
        if (view.alpha > 0.3) {
            view.alpha = 0.25; // Делаем прозрачной на 75%
        }
        return;
    }
    
    // Рекурсивный поиск по остальным слоям
    for (UIView *subview in view.subviews) {
        processAntiBurn(subview);
    }
}

__attribute__((constructor))
static void init_antiburn(void) {
    // Сканируем экран каждую секунду
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

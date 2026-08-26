#import <UIKit/UIKit.h>

static void makeUIElementsTransparent(UIView *parentView, CGFloat targetAlpha) {
    for (UIView *subview in parentView.subviews) {
        // Проверяем, является ли элемент иконкой, текстом или кнопкой
        if ([subview isKindOfClass:[UIImageView class]] || 
            [subview isKindOfClass:[UILabel class]] || 
            [subview isKindOfClass:[UIButton class]]) {
            
            // Уменьшаем видимость до 25%
            subview.alpha = targetAlpha;
        }
        
        // Рекурсивно проверяем все вложенные контейнеры
        makeUIElementsTransparent(subview, targetAlpha);
    }
}

__attribute__((constructor))
static void init_antiburn(void) {
    // Каждые 2 секунды сканируем экран и делаем все новые иконки/тексты полупрозрачными
    [NSTimer scheduledTimerWithTimeInterval:2.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSSet *connectedScenes = [UIApplication sharedApplication].connectedScenes;
            for (UIScene *scene in connectedScenes) {
                if ([scene isKindOfClass:[UIWindowScene class]]) {
                    UIWindowScene *windowScene = (UIWindowScene *)scene;
                    for (UIWindow *window in windowScene.windows) {
                        if (window.isKeyWindow) {
                            // 0.25 означает 25% видимости (иконки будут еле заметны и спасут экран)
                            makeUIElementsTransparent(window, 0.25);
                        }
                    }
                }
            }
        });
    }];
}

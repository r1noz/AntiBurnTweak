#import <UIKit/UIKit.h>

__attribute__((constructor))
static void init_antiburn(void) {
    // Выполняется автоматически сразу при запуске dylib
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // Находим главное активное окно TikTok
        UIWindow *mainContainer = nil;
        NSArray<UIWindow *> *windows = [UIApplication sharedApplication].windows;
        for (UIWindow *window in windows) {
            if (window.isKeyWindow) {
                mainContainer = window;
                break;
            }
        }
        if (!mainContainer && windows.count > 0) {
            mainContainer = windows.firstObject;
        }

        if (mainContainer) {
            // Создаем яркий тестовый оверлей (красный прозрачный)
            UIView *overlay = [[UIView alloc] initWithFrame:mainContainer.bounds];
            overlay.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.35]; // Красный для проверки
            overlay.userInteractionEnabled = NO; // Пропускает нажатия
            overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            
            [mainContainer addSubview:overlay];
        }
    });
}

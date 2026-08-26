#import <UIKit/UIKit.h>

__attribute__((constructor))
static void init_antiburn(void) {
    // Ждем 3 секунды, чтобы TikTok точно успел полностью загрузить свой интерфейс
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIWindow *mainContainer = nil;
        
        // Современный способ получения окон для iOS 15+ (без ошибок компиляции)
        NSSet *connectedScenes = [UIApplication sharedApplication].connectedScenes;
        for (UIScene *scene in connectedScenes) {
            if ([scene isKindOfClass:[UIWindowScene class]]) {
                UIWindowScene *windowScene = (UIWindowScene *)scene;
                for (UIWindow *window in windowScene.windows) {
                    if (window.isKeyWindow) {
                        mainContainer = window;
                        break;
                    }
                }
            }
        }
        
        // Если главное окно не найдено сразу, берем просто первое доступное окно на экране
        if (!mainContainer) {
            for (UIScene *scene in connectedScenes) {
                if ([scene isKindOfClass:[UIWindowScene class]]) {
                    UIWindowScene *windowScene = (UIWindowScene *)scene;
                    if (windowScene.windows.count > 0) {
                        mainContainer = windowScene.windows.firstObject;
                        break;
                    }
                }
            }
        }

        if (mainContainer) {
            // Создаем наш слой
            UIView *overlay = [[UIView alloc] initWithFrame:mainContainer.bounds];
            overlay.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.35]; // Красный цвет для теста
            overlay.userInteractionEnabled = NO; // Пропускает все тапы сквозь себя
            overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            
            // Добавляем в окно и принудительно вытягиваем на самый передний план!
            [mainContainer addSubview:overlay];
            [mainContainer bringSubviewToFront:overlay];
        }
    });
}

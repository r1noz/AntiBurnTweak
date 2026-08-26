#import <UIKit/UIKit.h>

static void processViewForAntiBurn(UIView *view) {
    if (view.hidden || view.alpha == 0.0) return;
    
    // Получаем оригинальное название класса элемента из кода TikTok
    NSString *className = NSStringFromClass([view class]);
    
    // Проверяем, содержит ли название элемента нужные нам ключевые слова
    BOOL isTargetUI = 
        [className containsString:@"TabBar"] ||        // Нижняя панель меню
        [className containsString:@"FeedInteract"] ||  // Правая колонка кнопок в ленте
        [className containsString:@"FeedSegment"] ||   // Верхние надписи (Подписки / Рекомендации)
        [className containsString:@"FeedLike"] ||      // Отдельная кнопка лайка
        [className containsString:@"FeedComment"] ||   // Отдельная кнопка комментов
        [className containsString:@"FeedShare"] ||     // Отдельная кнопка репоста
        [className containsString:@"MusicView"] ||     // Крутящаяся пластинка с треком
        [className containsString:@"FeedProfile"];     // Аватарка автора справа
    
    // Если это элемент из ленты — затеняем его
    if (isTargetUI) {
        if (view.alpha > 0.3) {
            view.alpha = 0.25; // Снижаем видимость до 25%
        }
        // Дальше внутрь этой кнопки не лезем, чтобы не дублировать прозрачность
        return; 
    }
    
    // Если это обычный элемент (например, чат или профиль), просто ищем дальше
    for (UIView *subview in view.subviews) {
        processViewForAntiBurn(subview);
    }
}

__attribute__((constructor))
static void init_antiburn(void) {
    // Сканируем интерфейс каждые 1.5 секунды
    [NSTimer scheduledTimerWithTimeInterval:1.5 repeats:YES block:^(NSTimer * _Nonnull timer) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSSet *connectedScenes = [UIApplication sharedApplication].connectedScenes;
            for (UIScene *scene in connectedScenes) {
                if ([scene isKindOfClass:[UIWindowScene class]]) {
                    UIWindowScene *windowScene = (UIWindowScene *)scene;
                    for (UIWindow *window in windowScene.windows) {
                        if (window.isKeyWindow) {
                            processViewForAntiBurn(window);
                        }
                    }
                }
            }
        });
    }];
}

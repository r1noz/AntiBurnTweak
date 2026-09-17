#import <UIKit/UIKit.h>

static void applyAntiBurn(UIView *view) {
    if (view.hidden || view.alpha == 0.0) return;
    
    NSString *className = NSStringFromClass([view class]);
    
    // Точные классы элементов TikTok (найденные через FLEX):
    BOOL isTargetElement = 
        [className isEqualToString:@"TTKTabBarButton"] ||
        [className isEqualToString:@"AWETabBarPlusButton"] ||
        [className isEqualToString:@"TTKTabBarBlurView"] ||
        [className containsString:@"FeedInteract"] ||  // Боковая колонка (лайк, комменты, репост)
        [className containsString:@"FeedSegment"];    // Верхняя шапка (Подписки / Рекомендации)

    if (isTargetElement) {
        if (view.alpha > 0.3) {
            view.alpha = 0.25; // Прозрачность 25%
        }
        return;
    }
    
    for (UIView *subview in view.subviews) {
        applyAntiBurn(subview);
    }
}

__attribute__((constructor))
static void init_antiburn(void) {
    [NSTimer scheduledTimerWithTimeInterval:1.5 repeats:YES block:^(NSTimer * _Nonnull timer) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSSet *connectedScenes = [UIApplication sharedApplication].connectedScenes;
            for (UIScene *scene in connectedScenes) {
                if ([scene isKindOfClass:[UIWindowScene class]]) {
                    UIWindowScene *windowScene = (UIWindowScene *)scene;
                    for (UIWindow *window in windowScene.windows) {
                        if (window.isKeyWindow) {
                            applyAntiBurn(window);
                        }
                    }
                }
            }
        });
    }];
}

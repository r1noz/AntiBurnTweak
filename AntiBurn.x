#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface AntiBurnOverlayView : UIView
@end

@implementation AntiBurnOverlayView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 1. Делаем слой полностью "прозрачным" для пальцев (тапы проходят сквозь него)
        self.userInteractionEnabled = NO;
        
        // 2. Настройка защитного слоя (полупрозрачный темно-серый фильтр)
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        // 3. Добавляем динамику: каждые 60 секунд слой меняет прозрачность на ±5%, 
        // чтобы пиксели под ним не находились в статике
        [NSTimer scheduledTimerWithTimeInterval:60.0 
                                         repeats:YES 
                                           block:^(NSTimer * _Nonnull timer) {
            [UIView animateWithDuration:2.0 animations:^{
                CGFloat randomAlpha = 0.15 + ((arc4random_uniform(15)) / 100.0);
                self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:randomAlpha];
            }];
        }];
    }
    return self;
}

// Дополнительная защита: игнорируем любые попытки перехватить касание
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    return nil; 
}

@end

// Внедрение слоя при старте приложения
%hook UIWindow

- (void)makeKeyAndVisible {
    %orig;
    
    // Проверяем, не добавлен ли уже наш слой
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            AntiBurnOverlayView *overlay = [[AntiBurnOverlayView alloc] initWithFrame:self.bounds];
            [self addSubview:overlay];
        });
    });
}

%end

#import <UIKit/UIKit.h>

__attribute__((constructor))
static void init_antiburn(void) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIWindow *mainContainer = nil;
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

        if (mainContainer) {
            CGRect W = mainContainer.bounds;
            
            CGRect bottomRect = CGRectMake(0, W.size.height - 95, W.size.width, 95);
            UIView *bottomOverlay = [[UIView alloc] initWithFrame:bottomRect];
            bottomOverlay.backgroundColor = [UIColor blackColor];
            bottomOverlay.userInteractionEnabled = NO;
            [mainContainer addSubview:bottomOverlay];
            
            CGRect rightRect = CGRectMake(W.size.width - 80, W.size.height * 0.35, 80, W.size.height * 0.52);
            UIView *rightOverlay = [[UIView alloc] initWithFrame:rightRect];
            rightOverlay.backgroundColor = [UIColor blackColor];
            rightOverlay.userInteractionEnabled = NO;
            [mainContainer addSubview:rightOverlay];

            CGRect topRect = CGRectMake(0, 0, W.size.width, 110);
            UIView *topOverlay = [[UIView alloc] initWithFrame:topRect];
            topOverlay.backgroundColor = [UIColor blackColor];
            topOverlay.userInteractionEnabled = NO;
            [mainContainer addSubview:topOverlay];
        }
    });
}

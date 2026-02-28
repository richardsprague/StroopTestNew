//
//  STSceneDelegate.m
//  StroopTestNew
//

#import "STSceneDelegate.h"

@implementation STSceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    // The storyboard is configured in Info.plist (UISceneStoryboardFile),
    // so the window and initial view controller are created automatically.
}

- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Save Core Data changes when entering background.
    id appDelegate = UIApplication.sharedApplication.delegate;
    if ([appDelegate respondsToSelector:@selector(saveContext)]) {
        [appDelegate performSelector:@selector(saveContext)];
    }
}

@end

//
//  STSceneVC.h
//  StroopTestNew
//
//  Created by Richard Sprague on 3/26/13.
//  Copyright (c) 2013 Richard Sprague. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STScene.h" 
#import "STSettings.h"

@protocol STSceneProtocol;

@interface STSceneVC : UIViewController
@property (strong, nonatomic) STScene *scene;



@property (nonatomic, weak) id <STSceneProtocol>delegate;
@end

@protocol STSceneProtocol <NSObject>

- (void ) StroopTestScorePlusOne;
- (void) cancelTest;

@end

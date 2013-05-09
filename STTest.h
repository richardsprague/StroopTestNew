//
//  STTest.h
//  StroopTestNew
//
//  Created by Richard Sprague on 3/27/13.
//  Copyright (c) 2013 Richard Sprague. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STScene.h"

@interface STTest : NSObject 

@property uint finalScore;
@property float completionTimeInSeconds;

- (id) initTestWithScene: (STScene *) latestScene;
- (STScene *) currentScene ;

@end

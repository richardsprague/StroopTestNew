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

@property uint currentScore;


@property (strong, nonatomic) STScene *latestScene;

- (NSTimeInterval) elapsedTime;



@end

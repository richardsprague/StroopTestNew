//
//  STTest.m
//  StroopTestNew
//
//  Created by Richard Sprague on 3/27/13.
//  Copyright (c) 2013 Richard Sprague. All rights reserved.
//

#import "STTest.h"


@interface STTest()

@property (strong, nonatomic) STScene *latestScene;


@end

@implementation STTest

- (STScene *) currentScene
{
    return self.latestScene;
}
- (id) initTestWithScene: (STScene *) latestScene;
{
    self = [super init];
    self.latestScene = latestScene;
    return self;
    
}

@synthesize completionTimeInSeconds = _completionTimeInSeconds;

- (float) completionTimeInSeconds
{
    return self.completionTimeInSeconds;
    
}

- (void) setCompletionTimeInSeconds:(float)completionTimeInSeconds
{
    _completionTimeInSeconds = completionTimeInSeconds;
    
}

@end


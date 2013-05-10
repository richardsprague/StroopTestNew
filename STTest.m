//
//  STTest.m
//  StroopTestNew
//
//  Created by Richard Sprague on 3/27/13.
//  Copyright (c) 2013 Richard Sprague. All rights reserved.
//

#import "STTest.h"


@interface STTest()
@property (strong, nonatomic) NSDate *startTime;

@end


@implementation STTest

- (id) init
{
    self = [super init];
    
    self.startTime = [[NSDate alloc] init];
    
    return self;
}

- (NSTimeInterval) elapsedTime
{
    return -[self.startTime timeIntervalSinceNow];
    
}



@end


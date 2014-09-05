//
//  STScene.m
//  StroopTestNew
//
//  Created by Richard Sprague on 3/26/13.
//  Copyright (c) 2013 Richard Sprague. All rights reserved.
//

#import "STScene.h"
@interface STScene()



@end
@implementation STScene


- (id) init
{ self = [super init];
    
    if (!_card) {
        _card = [[STCard alloc] init];
    }
    _selections = [[NSArray alloc] initWithArray:_card.shuffledColors];
    
    return self;
}


@end

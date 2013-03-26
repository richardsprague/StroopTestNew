//
//  STScene.h
//  StroopTestNew
//
//  Created by Richard Sprague on 3/26/13.
//  Copyright (c) 2013 Richard Sprague. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STCard.h"
#import "STScores.h"

@interface STScene : NSObject
@property (strong, nonatomic) STCard *card;
@property (strong, nonatomic) NSArray *selections;
@property uint latestScore;


@end

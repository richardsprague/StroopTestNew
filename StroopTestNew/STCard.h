//
//  STCard.h
//  StroopTestNew
//
//  Created by Richard Sprague on 3/26/13.
//  Copyright (c) 2013 Richard Sprague. All rights reserved.
//
// A card has its own color, plus an randomly-ordered array of all possible card colors.

#import <Foundation/Foundation.h>
#import "STColors.h"

@interface STCard : NSObject
@property (strong, nonatomic) STColors *color;
@property (strong, nonatomic) NSArray *shuffledColors;
+ (NSArray *) shuffledColorArray;

@end

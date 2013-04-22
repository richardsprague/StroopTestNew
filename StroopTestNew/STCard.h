//
//  STCard.h
//  StroopTestNew
//
//  Created by Richard Sprague on 3/26/13.
//  Copyright (c) 2013 Richard Sprague. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STColors.h"

@interface STCard : NSObject
@property (strong, nonatomic) STColors *color;
@property (strong, nonatomic) NSArray *shuffledColors;


@end

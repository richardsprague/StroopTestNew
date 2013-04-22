//
//  STCardView.h
//  StroopTestNew
//
//  Created by Richard Sprague on 3/27/13.
//  Copyright (c) 2013 Richard Sprague. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STColors.h"
#import "STCard.h"
#import "STScene.h"

@interface STCardView : UIView
- (void) showCard: (STCard *) aCard;
//- (id) initWithCard: (STCard*) card;
@property (strong, nonatomic) STColors *cardColor;

@end

//
//  STCardView.m
//  StroopTestNew
//
//  Created by Richard Sprague on 3/27/13.
//  Copyright (c) 2013 Richard Sprague. All rights reserved.
//

#import "STCardView.h"

@interface STCardView()
@property STCard *currentCard;

@end

@implementation STCardView


@synthesize currentCard = _currentCard;

- (STCard *) currentCard
{
    if (!_currentCard) _currentCard = [[STCard alloc] init];
    return _currentCard;
    
}

- (void) setCurrentCard:(STCard *)currentCard
{
    _currentCard = currentCard;
    
}

- (void) showCard: (STCard *) aCard
{
        self.backgroundColor = aCard.color;
}

- (id) initWithCard: (STCard*) card
{
    self = [super init];
    self.currentCard = card;
    
    return self;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

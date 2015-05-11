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
#define CORNER_RADIUS 12.0

#define PIP_FONT_SCALE_FACTOR 0.20
#define CORNER_OFFSET 10.0

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:CORNER_RADIUS];
    
    [roundedRect addClip];
    
//    [[UIColor whiteColor] setFill];
    [self.cardColor.colorAsUIColor setFill];

    
    
    NSString *currentColorString = @"color" ; //[self.cardColor colorNameAsString];
    //[STColors colorAsString:[[STColors alloc]  init].randomUIColor];
    
 //new   NSString * currentColorString = [[[STColors alloc] init] colorNameAsString];
    
    UIRectFill(self.bounds);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    UIFont *cornerFont = [UIFont systemFontOfSize:self.bounds.size.width * PIP_FONT_SCALE_FACTOR];
    
    // this will draw NSString *currentColorString in the upper left corner of the card.
    // currently disabled.
//    NSAttributedString *cornerText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", currentColorString] attributes:@{ NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : cornerFont }];
    
//    CGRect textBounds;
//    textBounds.origin =  CGPointMake(CORNER_OFFSET, CORNER_OFFSET);
//    textBounds.size = [cornerText size];
//    [cornerText drawInRect:textBounds];
//
//    // [self pushContextAndRotateUpsideDown];
//    [cornerText drawInRect:textBounds];
//    //  [self popContext];
    
    [[STColors blackColor] setStroke];
    [roundedRect stroke];
}


//- (void)drawCorners
//{
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.alignment = NSTextAlignmentCenter;
//    
//    UIFont *cornerFont = [UIFont systemFontOfSize:self.bounds.size.width * PIP_FONT_SCALE_FACTOR];
//    
//    NSAttributedString *cornerText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@", @"hello", @"there"] attributes:@{ NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : cornerFont }];
//    
//    CGRect textBounds;
//    textBounds.origin = CGPointMake(CORNER_OFFSET, CORNER_OFFSET);
//    textBounds.size = [cornerText size];
//    [cornerText drawInRect:textBounds];
//    
//   // [self pushContextAndRotateUpsideDown];
//    [cornerText drawInRect:textBounds];
//  //  [self popContext];
//}

//@synthesize currentCard = _currentCard;
//
//- (STCard *) currentCard
//{
//    if (!_currentCard) _currentCard = [[STCard alloc] init];
//    return _currentCard;
//    
//}
//
//- (void) setCurrentCard:(STCard *)currentCard
//{
//    _currentCard = currentCard;
//    
//}

- (void) showCard: (STCard *) aCard
{
 // self.backgroundColor = aCard.color;
    self.cardColor =   aCard.color;
  //  [self drawCorners];
    [self setNeedsDisplay];
    
  
}

- (id) initWithCard: (STCard*) card
{
    self = [super init];
    self.currentCard = card;
    self.cardColor = card.color;
    
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

@end

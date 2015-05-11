//
//  STColors.m
//  StroopTestNew
//
//  Created by Richard Sprague on 3/26/13.
//  Copyright (c) 2013 Richard Sprague. All rights reserved.
//

#import "STColors.h"

#define XHEXCOLOR(c) colorWithRed:((c>>24)&0xFF)/255.0 green:((c>>16)&0xFF)/255.0 blue:((c>>8)&0xFF)/255.0 alpha:((c)&0xFF)/255.0

#define XINITWITHHEXCOLOR(c) initWithRed:((c>>24)&0xFF)/255.0 green:((c>>16)&0xFF)/255.0 blue:((c>>8)&0xFF)/255.0 alpha:((c)&0xFF)/255.0

// #define STCOLORALLOCINIT(c) [[[STColors alloc] init] c];

#define XGREENCOLOR XHEXCOLOR(0x66CC66FF)
#define INITWITHGREENCOLOR XINITWITHHEXCOLOR(0x66CC66FF)
//[[STColors alloc] INITWITHGREENCOLOR]
@interface STColors()


@end

@implementation STColors

+ (NSArray *) colorAndColorNamesArray
{
    return @[
             @[[STColors greenColor],@"green"],
             @[[STColors blueColor],@"blue"],
             @[[STColors redColor], @"red" ]];
    
}

+ (NSDictionary *) ColorToStringDictionary
{
    return @{[STColors greenColor]: @"green",
             [STColors blueColor]: @"blue",
             [STColors redColor] : @"red"
             };
}

+ (NSString *) colorAsString:(STColors *)aColor
{
    NSDictionary *colorDict = [STColors ColorToStringDictionary];
    NSString *colorString = colorDict[aColor];
    assert(colorString!=nil);
    
    return colorString;
}

- (BOOL) isMatch: (STColors *)withColor
{
    
  
      CGFloat *myRed=NULL, *myGreen=NULL, *myBlue=NULL, *myAlpha = NULL;
      CGFloat *OtherRed=NULL, *otherGreen=NULL, *otherBlue=NULL, *otherAlpha = NULL;
   
    
    [self getRed:(CGFloat *)myRed green:myGreen blue:myBlue alpha: myAlpha];
    
    [withColor getRed:OtherRed green:otherGreen blue:otherBlue alpha:otherAlpha];
    
    if ((myRed == OtherRed) & (myGreen == otherGreen) & (myBlue ==otherBlue) & (myAlpha==otherAlpha))
        return YES;
    else return NO;
    
    
    
}
//
//- (STColors *) randomUIColor {
//    
//    if (!_randomUIColor){
//        unsigned int index = arc4random() % [[STColors colorAndColorNamesArray] count];
//        _randomUIColor = [[STColors alloc] init];
//        _randomUIColor = [STColors colorAndColorNamesArray][index][0];
//    }
//    return _randomUIColor;
//
//
//}

- (id) init
{
    self = [super init];
    unsigned int index = arc4random() % [[STColors colorAndColorNamesArray] count];
  
    _colorAsUIColor = [STColors colorAndColorNamesArray][index][0];
    _colorNameAsString = [STColors colorAndColorNamesArray][index][1];
    
 
    
    return self;
    
}


@end

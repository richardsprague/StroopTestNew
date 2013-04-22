//
//  STColors.m
//  StroopTestNew
//
//  Created by Richard Sprague on 3/26/13.
//  Copyright (c) 2013 Richard Sprague. All rights reserved.
//

#import "STColors.h"

@implementation STColors

+ (NSArray *) colorAndColorNamesArray
{
    return @[
             @[[UIColor greenColor],@"green"],
             @[[UIColor blueColor],@"blue"],
             @[[UIColor redColor], @"red" ]];
    
}

+ (NSDictionary *) ColorToStringDictionary
{
    return @{[UIColor greenColor]: @"green",
             [UIColor blueColor]: @"blue",
             [UIColor redColor] : @"red"
             };
}

+ (NSString *) colorAsString:(UIColor *)aColor
{
    NSDictionary *colorDict = [STColors ColorToStringDictionary];
    NSString *colorString = colorDict[aColor];
    
    return colorString;
}



- (STColors *) randomUIColor {
    
    if (!_randomUIColor){
        unsigned int index = arc4random() % [[STColors colorAndColorNamesArray] count];
        _randomUIColor = [STColors colorAndColorNamesArray][index][0];
    }
    return _randomUIColor;


}



@end

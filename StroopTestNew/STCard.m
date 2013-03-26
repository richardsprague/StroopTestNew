//
//  STCard.m
//  StroopTestNew
//
//  Created by Richard Sprague on 3/26/13.
//  Copyright (c) 2013 Richard Sprague. All rights reserved.
//

#import "STCard.h"

@implementation STCard
- (id) init
{ self = [super init];
    // NSLog(@"init ColorCard");
    if (!_color) _color = self.color;
    
    
    return self;
}
- (UIColor *) color
{
    
    if (!_color) _color = [STCard randomColor];
  //  _colorName = [STCard colorAsString:_color];
    
    
    
    //  NSLog(@"colorName= %@", self.colorName);
    
    // NSLog(@"setColor=%@",_color.description);
    
    return _color;
    
}


+ (NSArray *) colorArray
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
    NSDictionary *colorDict = [STCard ColorToStringDictionary];
    NSString *colorString = colorDict[aColor];
    
    return colorString;
}



+ (UIColor *) randomColor {
    
    
    unsigned int index = arc4random() % [[STCard colorArray] count];
    return [STCard colorArray][index][0];
    
}
@end

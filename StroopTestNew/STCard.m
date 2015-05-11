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
    
    STColors *newColor =[[STColors alloc] init];
    _color = newColor; //.colorAsUIColor;
    
    _shuffledColors = self.shuffledColors;
   
//    if (!_color) {
//        _color = self.color;
//        _shuffledColors = self.shuffledColors;
//        
    
 //   }
    
    
    return self;
}



//- (STColors *) color
//{
//    
//    if (!_color) {
//        _color = [[STColors alloc] init]; //[[[STColors alloc] init] randomUIColor]; //[[STColors alloc]  init]; //
//    }
//    
//    return _color;
//    
//}

- (NSArray *) shuffledColors
{
    if (!_shuffledColors){
        NSMutableArray *newColorArray = [[NSMutableArray alloc] initWithArray:[STColors colorAndColorNamesArray]];
        NSArray *anotherArray =  [STCard shuffle:newColorArray];
        
        
        _shuffledColors = [[NSArray alloc] initWithArray:(NSArray *) anotherArray];
        
    }
    
    
    return _shuffledColors;
}

+ (NSArray *) shuffledColorArray
{
    NSMutableArray *newColorArray = [[NSMutableArray alloc] initWithArray:[STColors colorAndColorNamesArray]];
    NSArray *anotherArray =  [STCard shuffle:newColorArray];
    
    return anotherArray;
    
}

+ (NSArray *) shuffle: (NSMutableArray *) anArray
{
//    for (NSUInteger i=0;i<[anArray count];i++){
//        NSUInteger nElements = anArray.count -i;
//        int n = arc4random_uniform(nElements) + i;
//        [anArray exchangeObjectAtIndex:i withObjectAtIndex:n ];
//        
//    }
    
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:anArray];
    NSUInteger count = [mutableArray count];
    // See http://en.wikipedia.org/wiki/Fisher–Yates_shuffle
    if (count > 1) {
        for (NSUInteger i = count - 1; i > 0; --i) {
            [mutableArray exchangeObjectAtIndex:i withObjectAtIndex:arc4random_uniform((int32_t)(i + 1))];
        }
    }
    
    NSArray *randomArray = [NSArray arrayWithArray:mutableArray];
    return randomArray;
}

@end

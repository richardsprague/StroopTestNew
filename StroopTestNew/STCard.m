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
   // NSLog(@"init STCard");
    if (!_color) {
            _color = self.color;
        _shuffledColors = self.shuffledColors;
        
    }
    
    
    return self;
}
- (UIColor *) color
{
    
    if (!_color) {
   _color = [[[STColors alloc]  init] randomUIColor];
    }
    
 
  //  _colorName = [STCard colorAsString:_color];
    
    
    
    //  NSLog(@"colorName= %@", self.colorName);
    
    // NSLog(@"setColor=%@",_color.description);
    
    return _color;
    
}

- (NSArray *) shuffledColors
{
    if (!_shuffledColors){
        NSMutableArray *newColorArray = [[NSMutableArray alloc] initWithArray:[STColors colorAndColorNamesArray]];
        NSArray *anotherArray =  [self shuffle:newColorArray];
        
        
        _shuffledColors = [[NSArray alloc] initWithArray:(NSArray *) anotherArray];
        
    }
    
    
    return _shuffledColors;
}


- (NSMutableArray *) shuffle: (NSMutableArray *) anArray
{
    for (uint i=0;i<[anArray count];i++){
        int nElements = anArray.count -i;
        int n = arc4random_uniform(nElements) + i;
        [anArray exchangeObjectAtIndex:i withObjectAtIndex:n ];
        
    }
    return anArray;
}

@end

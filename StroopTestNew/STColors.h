//
//  STColors.h
//  StroopTestNew
//
//  Created by Richard Sprague on 3/26/13.
//  Copyright (c) 2013 Richard Sprague. All rights reserved.
//
// Handles colors for you, with handy methods for getting an array of
// colors, converting colors to other types, and generally anything that
// might be useful for working with colors.
// This class lets you think about colors abstractly. You should never
// need to know the exact data structure used to store and keep colors.
// For all you know, colors are implemented with completely new and unknown data structures.


#import <Foundation/Foundation.h>

@interface STColors : NSObject
+ (NSArray *) colorAndColorNamesArray;
+ (NSString *) colorAsString:(UIColor *)aColor;
@property (weak, nonatomic) UIColor *randomUIColor ;
@end

//
//  StroopData+MOC.m
//  StroopTestNew
//
//  Created by Richard Sprague on 3/13/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import "StroopData+MOC.h"

@implementation StroopData (MOC)

-(void) prepareForDeletion {
    
   // StroopData *item = self.date;
    
    NSLog(@"deleting something with this date: %@",self.date);
}

@end

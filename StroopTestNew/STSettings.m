//
//  STSettings.m
//  StroopTestNew
//
//  Created by Richard Sprague on 3/26/13.
//  Copyright (c) 2013 Richard Sprague. All rights reserved.
//

#import "STSettings.h"

@implementation STSettings



+ (BOOL) isScoreMode
{ // score mode is zero; any other mode would return FALSE
    
    NSInteger STMode = [[NSUserDefaults standardUserDefaults] integerForKey:STMODE_KEY];
    return (!STMode);
    
    
    
}

+ (NSUInteger ) whichTimerMode {
    NSUInteger STMode = [[NSUserDefaults standardUserDefaults] integerForKey:STMODE_KEY];
    
    
    if (STMode) {
        
        
        switch (STMode) {
            case 1:
                return 15;
                break;
            case 2:
                return 30;
                break;
            case 3:
                return 60;
                break;
                
            default: NSLog(@"unknown STMode %lu",(unsigned long)STMode); return 0;
                break;
        }}
        else
            return 0;
    
}


- (id) init
{
    self = [super init];
    
    if (![[NSUserDefaults standardUserDefaults] integerForKey:STMODE_KEY]) {
        // no key set for STMODE, so
        //set STMODE_KEY to score mode (0)
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:STMODE_KEY];
        
        
    }
    // else just leave the default settings alone.
    
    return self;
}

@end

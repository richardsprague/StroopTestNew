//
//  STScores.m
//  StroopTestNew
//
//  Created by Richard Sprague on 3/26/13.
//  Copyright (c) 2013 Richard Sprague. All rights reserved.
//

#import "STScores.h"

@interface STScores()

@property (readwrite, nonatomic) NSDate *start;
@property (readwrite, nonatomic) NSDate *end;


@end

@implementation STScores



- (NSComparisonResult)dateCompare:(STScores *)aSTScores {
    return ([self.end compare:aSTScores.end]);
}

- (NSComparisonResult)scoreCompare:(STScores *)aSTScores {
    return ([@(self.score)compare:@(aSTScores.score)]);
}

- (NSComparisonResult)durationCompare:(STScores *)aSTScores {
    return ([@(self.duration)compare:@(aSTScores.duration)]);
}


+ (NSArray *)allSTScores
{
    NSMutableArray *allSTScores = [[NSMutableArray alloc] init];
    
    for(id plist in [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] allValues]) {
        STScores *result = [[STScores alloc] initFromPropertyList:plist];
        [allSTScores addObject:result];
    }
    return allSTScores;
}




- (id) initFromPropertyList:(id)plist
{
    //convenience initializer
    self = [self init];
    if (self) {
        if ([plist isKindOfClass:[NSDictionary class]]){
            NSDictionary *resultDictionary = (NSDictionary *)plist;
            _start = resultDictionary[START_KEY];
            _end = resultDictionary[END_KEY];
            _score = [resultDictionary[SCORE_KEY] intValue];
            if (!_start || !_end) self = nil;
            
        }
    }
    return self;
}



- (void) synchronize
{
    NSMutableDictionary *mutableSTScoresFromUserDefaults =
    [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY]
     
     mutableCopy];
    
    if (!mutableSTScoresFromUserDefaults)
        mutableSTScoresFromUserDefaults = [[NSMutableDictionary alloc] init];
    
    
    mutableSTScoresFromUserDefaults[[self.start description]] = [self asPropertyList];
    
    [[NSUserDefaults standardUserDefaults] setObject:mutableSTScoresFromUserDefaults forKey:ALL_RESULTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
}
#pragma mark - Sorting

- (NSComparisonResult)compareScoreToSTScores:(STScores *)otherResult
{
    if (self.score > otherResult.score) {
        return NSOrderedAscending;
    } else if (self.score < otherResult.score) {
        return NSOrderedDescending;
    } else {
        return NSOrderedSame;
    }
}

- (NSComparisonResult)compareEndDateToSTScores:(STScores *)otherResult
{
    return [otherResult.end compare:self.end];
}

- (NSComparisonResult)compareDurationToSTScores:(STScores *)otherResult
{
    if (self.duration > otherResult.duration) {
        return NSOrderedDescending;
    } else if (self.duration < otherResult.duration) {
        return NSOrderedAscending;
    } else {
        return NSOrderedSame;
    }
}



- (id) asPropertyList
{
    return @{ START_KEY: self.start, END_KEY : self.end, SCORE_KEY : @(self.score  )};
    
}

// designated initializer

- (id) init
{
    self = [super init];
    if (self) {
        _start = [NSDate date];
        _end = _start;
    }
    return self;
}

- (NSTimeInterval) duration
{
    return [self.end timeIntervalSinceDate:self.start];
}

- (void) setScore:(int)score
{
    _score = score;
    self.end = [NSDate date];
    [self synchronize];
    
    
}

@end
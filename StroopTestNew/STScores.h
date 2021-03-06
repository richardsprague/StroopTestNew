//
//  STScores.h
//  StroopTestNew
//
//  Created by Richard Sprague on 3/26/13.
//  Copyright (c) 2013 Richard Sprague. All rights reserved.
//
/*

#import <Foundation/Foundation.h>
#import "STSettings.h"

@interface STScores : NSObject

@property uint latestScore;

+ (NSArray *) allSTScoresFromNSUserDefaults; // of STScore

@property (readonly, nonatomic) NSDate *start;
@property (strong, nonatomic) NSDate *end;
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) int score;


- (NSComparisonResult)dateCompare:(STScores *)aSTScores;
- (NSComparisonResult)scoreCompare:(STScores *)aSTScores;
- (NSComparisonResult)durationCompare:(STScores *)aSTScores;


- (NSComparisonResult)compareScoreToSTScores:(STScores *)otherResult;
- (NSComparisonResult)compareEndDateToSTScores:(STScores *)otherResult;
- (NSComparisonResult)compareDurationToSTScores:(STScores *)otherResult;

+ (void) setAllSTUserDefaultScores: (NSArray *) newScores;

@end
*/
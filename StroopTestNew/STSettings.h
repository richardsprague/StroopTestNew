//
//  STSettings.h
//  StroopTestNew
//
//  Created by Richard Sprague on 3/26/13.
//  Copyright (c) 2013 Richard Sprague. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STColors.h"

#define ALL_RESULTS_KEY @"STScores_All"
#define START_KEY @"StartDate"
#define END_KEY @"EndDate"
#define SCORE_KEY @"Score"
#define DURATION_KEY @"Duration"


#define ST_LABEL_IN_ZENOBASE @"Stroop"
#define ST_ID_IN_ZENOBASE @"StroopID"

#define STMAXSCORE_KEY @"MaxScore"
#define STMAXSCORE_DEFAULT 3
#define STMAXTIMER_KEY @"MaxTime"
#define STTIMER_DEFAULT 30.0
#define STMODE_KEY @"PlayMode"
#define STMODE_DEFAULT 0 // 0 = play to max score, 1 = play for timer


@interface STSettings : NSObject
@property (nonatomic) uint latestScore;

+ (BOOL) isScoreMode;
+ (NSUInteger) whichTimerMode;
@end

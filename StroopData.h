//
//  StroopData.h
//  StroopTestNew
//
//  Created by Richard Sprague on 3/12/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface StroopData : NSManagedObject

@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * playMode;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSNumber * score;

@end

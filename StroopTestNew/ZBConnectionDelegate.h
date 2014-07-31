//
//  ZBConnectionDelegate.h
//  ZenobaseViewer
//
//  Created by Richard Sprague on 4/13/13.
//  Copyright (c) 2013 Richard Sprague. All rights reserved.
//
// This class knows how to talk to Zenobase.
// to use i
//
//


#import <Foundation/Foundation.h>
#import "ZBConnectionProtocol.h"

#define RECEIVED_JSON_FROM_ZENOBASE @"ReceivedJSONFromZenoBase"

@interface ZBConnectionDelegate : NSObject

- (void) getZBAccessTokenForUsername: (NSString *) username withPassword: (NSString *)password;
- (void) getBuckets;
- (void) getEventsForBucket: (NSString *) bucketIDString;
- (void) createNewBucket: (NSString *) newBucketName;
- (void) addNewEventToBucket: (NSString *) bucketID withEvent: (NSDictionary *) eventDict;

@property (strong, nonatomic) NSDictionary *ZBJsonResults;

@property (strong, nonatomic) id <ZBConnectionProtocol>delegate;


@end

//
//  STAppDelegate.m
//  StroopTestNew
//
//  Created by Richard Sprague on 3/26/13.
//  Copyright (c) 2013 Richard Sprague. All rights reserved.
//

#import "STAppDelegate.h"
#import <CoreData/CoreData.h>

@interface STAppDelegate ()
@property (strong, nonatomic) NSPersistentContainer *persistentContainer;
@end

@implementation STAppDelegate

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Initialize Core Data before anything else needs it.
    [self loadPersistentContainer];
    return YES;
}

#pragma mark - UISceneSession lifecycle

- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}

#pragma mark - Core Data stack

- (void)loadPersistentContainer {
    self.persistentContainer = [[NSPersistentContainer alloc] initWithName:@"ensembioStroop"];

    // Enable lightweight migration
    NSPersistentStoreDescription *storeDescription = self.persistentContainer.persistentStoreDescriptions.firstObject;
    storeDescription.shouldMigrateStoreAutomatically = YES;
    storeDescription.shouldInferMappingModelAutomatically = YES;

    [self.persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *description, NSError *error) {
        if (error) {
            NSLog(@"Core Data failed to load: %@", error);
        } else {
            NSLog(@"Core Data store loaded: %@", description.URL);
            self.managedObjectContext = self.persistentContainer.viewContext;
        }
    }];
}

- (void)saveContext {
    NSManagedObjectContext *context = self.managedObjectContext;
    if (context != nil) {
        NSError *error = nil;
        if ([context hasChanges] && ![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
}

@end

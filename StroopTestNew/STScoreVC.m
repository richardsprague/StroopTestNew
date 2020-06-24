//
//  STScoreVC.m
//  StroopTestNew
//
//  Created by Richard Sprague on 3/27/13.
//  Copyright (c) 2013 Richard Sprague. All rights reserved.
//

#import "STSettings.h"
#import "STScoreVC.h"
#import "StroopData.h"
#import "StroopData+MOC.h"


// tags needed so I can talk to UI elements in the custom tableviewcell
// these constants remain inside this file because they won't be used elsewhere
#define SCORELABELTAG 101
#define DATELABELTAG 102
#define DURATIONLABELTAG 103

@interface STScoreVC ()<UITableViewDataSource, UITableViewDelegate,  NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *secondsLabel;
@property (weak, nonatomic) IBOutlet UIButton *scoreLabel;
@property (weak, nonatomic) IBOutlet UITableView *STScoreTableView;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) NSManagedObjectContext *context;

//@property (weak, nonatomic) IBOutlet UITextView *STScoreDisplayTextView;
@property (strong, nonatomic) NSArray *allSTScores;
@property  (strong, nonatomic) NSArray *resultArray;  // a new array, created after deleting a row, stored back into NSUSerDefaults as the updated list of scores.
//@property (nonatomic) SEL sortSelector;
@end

@implementation STScoreVC



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    StroopData *item =[self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.context deleteObject:item];

    [self updateUI];
    
}
//- (void)deleteRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
//{
//
//    NSLog(@"deleting row");
//        [self.STScoreTableView setEditing:NO  ];
//    [self updateUI];
// 
//}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [[self.fetchedResultsController sections] count]; //1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    // Usually the number of items in your array (the one that holds your list)
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects]; //[self.allSTScores count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"STScoreTableRow";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...

     
    // prepare the labels on the parts of the cells
    UILabel *cellScoreLabel = (UILabel *)[cell.contentView viewWithTag:SCORELABELTAG];
    UILabel *cellDateLabel =(UILabel *)[cell.contentView viewWithTag:DATELABELTAG];
    UILabel *cellDurationLabel =(UILabel *)[cell.contentView viewWithTag:DURATIONLABELTAG];
    
/*****************/
     StroopData *item  = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSString *scoreSubString = [[NSString alloc] initWithFormat:@"%d",[item.score intValue]];
    NSString *dateSubString = [[NSString alloc] initWithFormat:@"%@", [NSDateFormatter localizedStringFromDate:item.date dateStyle:(NSDateFormatterShortStyle) timeStyle:NSDateFormatterShortStyle] ];
    NSString *durationSubString = [[NSString alloc] initWithFormat:@"%3.2f",[item.duration doubleValue]];
    
    NSUInteger mode = [STSettings whichTimerMode];
    
    if (mode) { // we're in a timer mode, so display that don't bother displaying the "seconds" list.
        
        self.secondsLabel.titleLabel.text = [[NSString alloc] initWithFormat:@"time:%2.1lu",(unsigned long)mode];
        self.scoreLabel.titleLabel.text = [[NSString alloc] initWithFormat:@"Score"];

         cellScoreLabel.text = scoreSubString;
        cellDurationLabel.alpha = 0.0;
        cellScoreLabel.alpha = 1.0;
        
    } else { // we're in Score mode, so don't populate cells that have scores, but display the score in the score button.
        cellScoreLabel.alpha =0.0;
        cellDurationLabel.text = durationSubString;
        cellDurationLabel.alpha = 1.0;
        self.scoreLabel.titleLabel.text = [[NSString alloc] initWithFormat:@"%lu",(unsigned long)[[NSUserDefaults standardUserDefaults] integerForKey:STMAXSCORE_KEY]];
        self.secondsLabel.titleLabel.text = [[NSString alloc] initWithFormat:@"Seconds"];
    }
   
    cellDateLabel.text = dateSubString;


    
/*****************/

    
    return cell;
}

// this is needed to squeeze more rows on a screen.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (self.STScoreTableView.isEditing)
    {
        return [UIFont systemFontSize]+22;
    }
    else

    return [UIFont smallSystemFontSize]+6;  //16.0;

}




- (IBAction)sortByDate:(id)sender {
    
    [self setFetchedResultsControllerSearchedByString:@"date"];
    [self updateUI];
    
//self.sortSelector = @selector(compareEndDateToSTScores:);
}

- (IBAction)sortByScore:(id)sender {
    [self setFetchedResultsControllerSearchedByString:@"score"];
    [self updateUI];
    //self.sortSelector = @selector(compareScoreToSTScores:);
}

- (IBAction)sortByTime:(id)sender {
    
    [self setFetchedResultsControllerSearchedByString:@"duration"];
    [self updateUI];
    
//self.sortSelector = @selector(compareDurationToSTScores:);
}

- (void) updateUI
{
    
    [self.STScoreTableView reloadData]; 
}



- (NSManagedObjectContext *) managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]){
        context = [delegate managedObjectContext];
    }
    
    return context;
}

- (void) setFetchedResultsControllerSearchedByString: (NSString *) sortString
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"StroopData"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:sortString ascending:NO],
                                     [NSSortDescriptor sortDescriptorWithKey: @"duration" ascending:YES]];
    
    
    //   self.results = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    // Only get the database records where playMode = current Playmode.
    
    id mode = [[NSUserDefaults standardUserDefaults] valueForKey:STMODE_KEY];
    
    
    // filter for everything in the database where attribute ResponseString = responseString
    NSPredicate *matchesString = [NSPredicate predicateWithFormat:@"%K == %@",@"playMode",mode];
    
    
    [fetchRequest setPredicate:matchesString];

    
    
    
    
    
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsController.delegate = self;
    
    NSError *error;
    bool success = [self.fetchedResultsController performFetch:&error];
    
    if (!success) {NSLog(@"no results from Fetch: %@",error.description);}
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.context = [self managedObjectContext];
    
    [self setFetchedResultsControllerSearchedByString:@"date"];
    
    
    [self updateUI];

}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateUI];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.STScoreTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self updateUI];
	// Do any additional setup after loading the view.
}



@end

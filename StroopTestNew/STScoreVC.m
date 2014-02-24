//
//  STScoreVC.m
//  StroopTestNew
//
//  Created by Richard Sprague on 3/27/13.
//  Copyright (c) 2013 Richard Sprague. All rights reserved.
//

#import "STScoreVC.h"
#import "STScores.h"

// tags needed so I can talk to UI elements in the custom tableviewcell
// these constants remain inside this file because they won't be used elsewhere
#define SCORELABELTAG 101
#define DATELABELTAG 102
#define DURATIONLABELTAG 103

@interface STScoreVC ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *STScoreTableView;

//@property (weak, nonatomic) IBOutlet UITextView *STScoreDisplayTextView;
@property (strong, nonatomic) NSArray *allSTScores;
@property  (strong, nonatomic) NSArray *resultArray;
@property (nonatomic) SEL sortSelector; 
@end

@implementation STScoreVC

/* vestigial code removed Feb2014
- (IBAction)editPushed:(UIButton *)sender {
    if (self.STScoreTableView.isEditing)
        [self.STScoreTableView setEditing:NO];
    else if ([self.resultArray count]>0){
        
    [self.STScoreTableView setEditing:YES  ];
    }
    
   [self updateUI];
    
}
*/

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
  //   STScores *result = self.resultArray [indexPath.row];
    NSMutableArray *rowsToDelete = [[NSMutableArray alloc] init];

        NSMutableArray *newScoreArray = [[NSMutableArray alloc] init];

    for ( uint i =0; i<[self.resultArray count] ; i++) {
        if (i==indexPath.row) {
            // add this row to rowsToDelete array
            [rowsToDelete addObject:[NSNumber numberWithUnsignedInt:i]];
            
        } else [newScoreArray addObject:self.resultArray[i]];
        
    }
    
    self.resultArray = [[NSArray alloc] initWithArray:newScoreArray];
    self.allSTScores = self.resultArray;
    NSLog(@"commit edit");
    [self deleteRowsAtIndexPaths:rowsToDelete withRowAnimation:UITableViewRowAnimationFade];
    
    [STScores setAllSTUserDefaultScores:self.resultArray];

    [self updateUI];
    
}
- (void)deleteRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{

    NSLog(@"deleting row");
        [self.STScoreTableView setEditing:NO  ];
    [self updateUI];
 
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    // Usually the number of items in your array (the one that holds your list)
    return [self.allSTScores count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"STScoreTableRow";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...

    
  //  cell.textLabel.font = [UIFont systemFontOfSize:14.0];//[[[UIFont alloc] init]fontWithSize:[UIFont smallSystemFontSize]];

   // cell.textLabel.text = [self titleForRow:indexPath.row];
    NSDictionary *titleDict = [self titleForRow:indexPath.row];
    
 /* original code pre-Feb2014
    cell.textLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
  // need that UTF8 conversion so it can be handled as a Char -- %s won't display NSString
    NSString *titleString =[[NSString alloc] initWithFormat:@"%10s%36s%18s",[[titleDict objectForKey:@"scoreString"] UTF8String],[[titleDict objectForKey:@"dateString"] UTF8String],[[titleDict objectForKey:@"durationString"]UTF8String] ];

    cell.textLabel.text = titleString;
    
    cell.textLabel.textAlignment = NSTextAlignmentLeft ;
    cell.textLabel.adjustsLetterSpacingToFitWidth=YES;
    
    cell.textLabel.textColor = [UIColor redColor];
*/
    UILabel *cellScoreLabel = (UILabel *)[cell.contentView viewWithTag:SCORELABELTAG];
    UILabel *cellDateLabel =(UILabel *)[cell.contentView viewWithTag:DATELABELTAG];
    UILabel *cellDurationLabel =(UILabel *)[cell.contentView viewWithTag:DURATIONLABELTAG];
    
    cellScoreLabel.text = [titleDict objectForKey:@"scoreString"];
    cellDateLabel.text = [titleDict objectForKey:@"dateString"];
    cellDurationLabel.text = [titleDict objectForKey:@"durationString"];

    //cell.detailTextLabel.text = [self titleForRow:indexPath.row];
    
    
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


//- (NSString *)titleForRow:(NSUInteger)row
// original pre-Feb2014 version returned a string carefully padded with blanks to simulate columns.
// Upgraded to return, instead, a dictionary with separate strings representing each item I want to display on the cell.
// this function is kept alone for backward compatibility reasons.  If you were doing it over, you'd probably just put these substrings inline in the main cellForRowAtIndexPath method above.

- (NSDictionary *) titleForRow:(NSUInteger) row
{
   // NSString *displayText = @"";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];          
    [formatter setTimeStyle:NSDateFormatterShortStyle];
   //
     self.resultArray = [[STScores allSTScoresFromNSUserDefaults] sortedArrayUsingSelector:self.sortSelector];
    assert(self.resultArray);
    
    STScores *result = self.resultArray [ row]; //self.allSTScores[row];
    
    NSString *scoreSubString = [[NSString alloc] initWithFormat:@"%d",result.score];
    NSString *dateSubString = [[NSString alloc] initWithFormat:@"%@", [formatter stringFromDate:result.end] ];
    NSString *durationSubString = [[NSString alloc] initWithFormat:@"%3.1f",result.duration];
    
    
  //  NSString *titleString = [[NSString alloc] initWithFormat:@"%10s%36s%18s",[scoreSubString UTF8String], [dateSubString UTF8String],[durationSubString UTF8String]];
    NSDictionary *titleDict = [[NSDictionary alloc] initWithObjectsAndKeys:scoreSubString ,@"scoreString",dateSubString,@"dateString",durationSubString,@"durationString", nil];
    
    
//    return titleString;
    return titleDict;
    
    //[SCORE_KEY] description]]; // description because could be NSNull
}


- (IBAction)sortByDate:(id)sender {
self.sortSelector = @selector(compareEndDateToSTScores:);
}

- (IBAction)sortByScore:(id)sender {
    self.sortSelector = @selector(compareScoreToSTScores:);
}

- (IBAction)sortByTime:(id)sender {
    self.sortSelector = @selector(compareDurationToSTScores:);
}

- (void) updateUI
{

//    NSString *displayText = @"";
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init]; 
//    [formatter setDateStyle:NSDateFormatterShortStyle];          
//    [formatter setTimeStyle:NSDateFormatterShortStyle];          
//
//    for (STScores *result in [[STScores allSTScoresFromNSUserDefaults] sortedArrayUsingSelector:self.sortSelector]) {
//        
//        displayText = [displayText stringByAppendingFormat:@"Score: %d (%@, %0g)\n", result.score, [formatter stringFromDate:result.end], result.duration];  // formatted date
//    }
  //  self.STScoreDisplayTextView.text = displayText;
    
    [self.STScoreTableView reloadData]; 
}

#pragma mark - Sorting

@synthesize sortSelector = _sortSelector;  // because we implement BOTH setter and getter

// return default sort selector if none set (by score)

- (SEL)sortSelector
{
    if (!_sortSelector) _sortSelector = @selector(compareScoreToSTScores:);
    return _sortSelector;
}

// update the UI when changing the sort selector

- (void)setSortSelector:(SEL)sortSelector
{
    _sortSelector = sortSelector;
    [self updateUI];
  //   [self.STScoreTableView reloadData];
}




- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.allSTScores = [STScores allSTScoresFromNSUserDefaults];
    [self updateUI];
//    [self.STScoreTableView reloadData];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateUI];
//        [self.STScoreTableView reloadData];
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.STScoreTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  //  [self updateUI];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

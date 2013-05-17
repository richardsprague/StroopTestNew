//
//  STScoreVC.m
//  StroopTestNew
//
//  Created by Richard Sprague on 3/27/13.
//  Copyright (c) 2013 Richard Sprague. All rights reserved.
//

#import "STScoreVC.h"
#import "STScores.h"

@interface STScoreVC ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *STScoreTableView;

//@property (weak, nonatomic) IBOutlet UITextView *STScoreDisplayTextView;
@property (strong, nonatomic) NSArray *allSTScores;
@property (nonatomic) SEL sortSelector; 
@end

@implementation STScoreVC

- (IBAction)editPushed:(UIButton *)sender {
    if (self.STScoreTableView.isEditing)
        [self.STScoreTableView setEditing:NO];
        else [self.STScoreTableView setEditing:YES  ];
    
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
    cell.textLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    cell.textLabel.text = [self titleForRow:indexPath.row];
    cell.textLabel.textColor = [UIColor redColor];

    //cell.detailTextLabel.text = [self titleForRow:indexPath.row];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UIFont smallSystemFontSize]+6;  //16.0;
}

- (NSString *)titleForRow:(NSUInteger)row
{
   // NSString *displayText = @"";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];          
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSArray *resultArray = [[STScores allSTScores] sortedArrayUsingSelector:self.sortSelector];
    STScores *result = resultArray [ row]; //self.allSTScores[row];
    
    NSString *titleString = [[NSString alloc]
                             initWithFormat:@"%-5d|        %16@ |       %5f",result.score,[formatter stringFromDate:result.end],result.duration];
    
    
    return titleString;
    
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

    NSString *displayText = @"";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init]; // added after lecture
    [formatter setDateStyle:NSDateFormatterShortStyle];          // added after lecture
    [formatter setTimeStyle:NSDateFormatterShortStyle];          // added after lecture
    // for (STScores *result in [STScores allSTScores]) { // version in lecture
    for (STScores *result in [[STScores allSTScores] sortedArrayUsingSelector:self.sortSelector]) { // sorted
        // displayText = [displayText stringByAppendingFormat:@"Score: %d (%@, %0g)\n", result.score, result.end,result.duration]; // version in lecture
        displayText = [displayText stringByAppendingFormat:@"Score: %d (%@, %0g)\n", result.score, [formatter stringFromDate:result.end], result.duration];  // formatted date
    }
  //  self.STScoreDisplayTextView.text = displayText;
    
    
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
     [self.STScoreTableView reloadData];   
}




- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.allSTScores = [STScores allSTScores];
    [self updateUI];
    [self.STScoreTableView reloadData];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateUI];
        [self.STScoreTableView reloadData];
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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

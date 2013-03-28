//
//  STScoreVC.m
//  StroopTestNew
//
//  Created by Richard Sprague on 3/27/13.
//  Copyright (c) 2013 Richard Sprague. All rights reserved.
//

#import "STScoreVC.h"
#import "STScores.h"

@interface STScoreVC ()
@property (weak, nonatomic) IBOutlet UITextView *STScoreDisplayTextView;
@property (strong, nonatomic) NSArray *allSTScores;
@property (nonatomic) SEL sortSelector; 
@end

@implementation STScoreVC

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
//    NSString *displayText= @"";
//    for (STScores *result in [STScores allSTScores]) {
//        displayText = [displayText stringByAppendingFormat:@"Score: %d (%@ %fs)\n", result.score,
//                       
//                       [NSDateFormatter localizedStringFromDate:result.end dateStyle: NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle],
//                       result.duration ];
//    }
//    self.STScoreDisplayTextView.text = displayText;
    NSString *displayText = @"";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init]; // added after lecture
    [formatter setDateStyle:NSDateFormatterShortStyle];          // added after lecture
    [formatter setTimeStyle:NSDateFormatterShortStyle];          // added after lecture
    // for (STScores *result in [STScores allSTScores]) { // version in lecture
    for (STScores *result in [[STScores allSTScores] sortedArrayUsingSelector:self.sortSelector]) { // sorted
        // displayText = [displayText stringByAppendingFormat:@"Score: %d (%@, %0g)\n", result.score, result.end,result.duration]; // version in lecture
        displayText = [displayText stringByAppendingFormat:@"Score: %d (%@, %0g)\n", result.score, [formatter stringFromDate:result.end], result.duration];  // formatted date
    }
    self.STScoreDisplayTextView.text = displayText;
    
    
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
}




- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.allSTScores = [STScores allSTScores];
    [self updateUI];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateUI];
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

//
//  STSettingsVC.m
//  StroopTestNew
//
//  Created by Richard Sprague on 3/26/13.
//  Copyright (c) 2013 Richard Sprague. All rights reserved.
//

#import "STSettingsVC.h"


@interface STSettingsVC ()
@property (weak, nonatomic) IBOutlet UILabel *STMaxScoreLabel;
// @property (weak, nonatomic) IBOutlet UIStepper *;
@property (weak, nonatomic) IBOutlet UISegmentedControl *STTimerSegmentControl;
@property (weak, nonatomic) IBOutlet UILabel *STSettingsVersionLabel;

@property (weak, nonatomic) IBOutlet UILabel *STTestTimesLabel;

@property (weak, nonatomic) IBOutlet UILabel *STTestDurationLabel;

@property (weak, nonatomic) IBOutlet UIStepper *STMaxScoreAdjustStepper;
@property uint STMaxScore;

@end

@implementation STSettingsVC


@synthesize STMaxScore = _STMaxScore;


- (IBAction)STResetScores:(UIButton *)sender {
    [[NSUserDefaults standardUserDefaults] setObject:NULL forKey:ALL_RESULTS_KEY];
}



- (IBAction)STTimerSegmentedControlClicked:(UISegmentedControl *)sender {
    
    
    if (!(sender.selectedSegmentIndex==0)) { // something other than OFF is selected
        
        
        [[NSUserDefaults standardUserDefaults] setFloat:STTIMER_DEFAULT forKey:STMAXTIMER_KEY];
        [[NSUserDefaults standardUserDefaults] setInteger:sender.selectedSegmentIndex forKey:STMODE_KEY];
        
        self.STMaxScoreLabel.Enabled = NO;
        self.STTestDurationLabel.enabled = YES;
               self.STTestTimesLabel.Enabled = NO;
               self.STMaxScoreAdjustStepper.enabled = NO;
        self.STMaxScoreAdjustStepper.alpha = 0.5;
        
    } else         {
        
    [[NSUserDefaults standardUserDefaults] setInteger:sender.selectedSegmentIndex forKey:STMODE_KEY];
           self.STMaxScoreLabel.Enabled = YES;
         self.STTestTimesLabel.Enabled = YES;
        self.STTestDurationLabel.enabled = NO;
        self.STMaxScoreAdjustStepper.enabled = YES;
        self.STMaxScoreAdjustStepper.alpha = 1.0;
}


}



- (IBAction)STMaxScoreAdjustStepper:(id)sender {
    
    self.STMaxScore = (uint) self.STMaxScoreAdjustStepper.value;

    self.STMaxScoreLabel.text = [[NSString alloc] initWithFormat:@"%d",self.STMaxScore];
    
}

- (IBAction)STSettingsSwipeLeft:(UISwipeGestureRecognizer *)sender {
            self.STSettingsVersionLabel.text = [NSString stringWithFormat:@"Version %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    
}

- (IBAction)STSettingsSwipeGesture:(UISwipeGestureRecognizer *)sender {
    
    self.STSettingsVersionLabel.text = [NSString stringWithFormat:@"Thanks for downloading!"];
}



- (void) setSTMaxScore:(uint)STMaxScore
{
    _STMaxScore = STMaxScore;
    [[NSUserDefaults standardUserDefaults] setInteger:(_STMaxScore) forKey:STMAXSCORE_KEY];
}

- (uint) STMaxScore
{
    
    int currentDefaultMaxScore = [[NSUserDefaults standardUserDefaults] integerForKey:STMAXSCORE_KEY];
    if (!currentDefaultMaxScore) {  // there is no default max score, probably because this is the first time the app has been run
        _STMaxScore = STMAXSCORE_DEFAULT;
        [[NSUserDefaults standardUserDefaults] setInteger:(STMAXSCORE_DEFAULT) forKey:STMAXSCORE_KEY];
  
    } else _STMaxScore = currentDefaultMaxScore;
    return _STMaxScore;
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
    
    self.STMaxScoreAdjustStepper.value =  (double) self.STMaxScore;
    self.STTimerSegmentControl.selectedSegmentIndex = [[NSUserDefaults standardUserDefaults] integerForKey:STMODE_KEY];
    
    if (self.STTimerSegmentControl.selectedSegmentIndex!=0){
        
        self.STMaxScoreLabel.Enabled = NO;
        self.STTestDurationLabel.enabled = YES;
        self.STTestTimesLabel.Enabled = NO;
        self.STMaxScoreAdjustStepper.enabled = NO;
        self.STMaxScoreAdjustStepper.alpha = 0.5;
    } else { self.STTestDurationLabel.enabled = NO;
    }
    
    
    self.STMaxScoreLabel.text = [[NSString alloc] initWithFormat:@"%d",self.STMaxScore];
    self.STSettingsVersionLabel.text = [NSString stringWithFormat:@"Version %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

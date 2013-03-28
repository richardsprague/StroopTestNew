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

@property (weak, nonatomic) IBOutlet UIStepper *STMaxScoreAdjustStepper;
@property uint STMaxScore;

@end

@implementation STSettingsVC


@synthesize STMaxScore = _STMaxScore;



- (IBAction)STMaxScoreAdjustStepper:(id)sender {
    
    self.STMaxScore = (uint) self.STMaxScoreAdjustStepper.value;

    self.STMaxScoreLabel.text = [[NSString alloc] initWithFormat:@"%d",self.STMaxScore];
    
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
    
    self.STMaxScoreLabel.text = [[NSString alloc] initWithFormat:@"%d",self.STMaxScore];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

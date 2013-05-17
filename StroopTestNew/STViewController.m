//
//  STViewController.m
//  StroopTestNew
//
//  Created by Richard Sprague on 3/26/13.
//  Copyright (c) 2013 Richard Sprague. All rights reserved.
//

#import "STViewController.h"
#import "STTest.h"


@interface STViewController ()<STSceneProtocol>
@property (weak, nonatomic) IBOutlet UILabel *elapsedSecondsLabel;
@property (weak, nonatomic) IBOutlet UILabel *STCorrectScoreLabel;
@property (strong, nonatomic) STScores *testResult;
@property (strong, nonatomic) STTest *stroopTest;
@property (strong, nonatomic) STSceneVC *nextView;
@property (strong, nonatomic) NSTimer *timerForTest;

@end

@implementation STViewController

@synthesize stroopTest = _stroopTest;

- (void) initializeSettingsIfNecessary
{
   // int STMode = [[NSUserDefaults standardUserDefaults] integerForKey:STMODE_KEY];
    
}

- (void) setStroopTest:(STTest *)newStroopTest
{
    if (!_stroopTest) _stroopTest = [[STTest alloc] init];
    else _stroopTest = newStroopTest;
    
}

- (STTest *) stroopTest
{
    
    if (!_stroopTest) {
        _stroopTest = [[STTest alloc] init];
        self.stroopTest = _stroopTest;
    }
    return _stroopTest;
    
}

- (void) STUpdateScore
{
    NSTimeInterval duration = self.stroopTest.elapsedTime;
    
    //warning!  You must set duration and score in this order
   self.testResult.duration = duration;
    self.testResult.score = self.stroopTest.currentScore;
    self.testResult = nil;
    
    
    
    self.STCorrectScoreLabel.text = [[NSString alloc] initWithFormat:@"Time's up! Score=%d",self.stroopTest.currentScore];
    if (duration>0.1){
        self.elapsedSecondsLabel.text = [[NSString alloc] initWithFormat:@"Seconds: %f",duration];
    }
    
}

- (void) StroopTestScorePlusOne
{
    self.stroopTest.currentScore++;
        self.STCorrectScoreLabel.text = [[NSString alloc] initWithFormat:@"Score: %d",self.stroopTest.currentScore];
  
        uint userDefaultNumTests;
    userDefaultNumTests = [[NSUserDefaults standardUserDefaults] integerForKey:STMAXSCORE_KEY];
    
    
    if (userDefaultNumTests==0) userDefaultNumTests=3;

    
    int STMode = [[NSUserDefaults standardUserDefaults] integerForKey:STMODE_KEY];
    
    
    if (!STMode) {   // STMode=0 means continue to max score
        if (self.stroopTest.currentScore>=userDefaultNumTests){ // only do this if we're done with the Test
    
            [self STUpdateScore];
            
            [self.nextView dismissViewControllerAnimated:YES completion:nil];
        }
    }
    
    
}

- (void) cancelTest
{
    [ self.timerForTest invalidate];
    self.STCorrectScoreLabel.text = [[NSString alloc] initWithFormat:@"Cancelled"];
    
}



- (STScores *) testResult
{
    if (!_testResult) _testResult = [[STScores alloc] init];
    return _testResult;
}

- (IBAction)startTestButtonPressed:(id)sender {

    
    int STMode = [[NSUserDefaults standardUserDefaults] integerForKey:STMODE_KEY];

    
    if (!(STMode==0)) {
        
        
        switch (STMode) {
            case 1:
                self.timerForTest = [NSTimer scheduledTimerWithTimeInterval: 15.0 target:self selector:@selector(STTimeExpired) userInfo:nil repeats:NO];
                break;
            case 2:
                self.timerForTest = [NSTimer scheduledTimerWithTimeInterval: 30.0 target:self selector:@selector(STTimeExpired) userInfo:nil repeats:NO];
                break;
            case 3:
                self.timerForTest = [NSTimer scheduledTimerWithTimeInterval: 60.0 target:self selector:@selector(STTimeExpired) userInfo:nil repeats:NO];
                break;
                
            default: NSLog(@"unknown STMode");
                break;
        }
        
    }
    
    
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.nextView = [segue destinationViewController];
    
    STScene *startingScene = [[STScene alloc] init];
    
    self.stroopTest = [[STTest alloc] init];
    
   self.stroopTest.latestScene = startingScene;
    

 self.nextView.scene = self.stroopTest.latestScene;
    self.nextView.delegate = self;
    
}

- (void) STTimeExpired
{
        
    [self STUpdateScore];
        [self.nextView dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self initializeSettingsIfNecessary];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

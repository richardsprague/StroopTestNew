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
//@property (weak, nonatomic) IBOutlet UILabel *STCorrectScoreLabel;
@property (strong, nonatomic) STScores *testResult;
@property (strong, nonatomic) STTest *stroopTest;
@property (strong, nonatomic) STSceneVC *nextView;
@property (strong, nonatomic) NSTimer *timerForTest;
@property NSFileManager *fileManager;
@property NSURL *userURL;
@property NSURL *myFileURL;

@end

@implementation STViewController

@synthesize stroopTest = _stroopTest;

- (void) initializeSettingsIfNecessary
{
   // int STMode = [[NSUserDefaults standardUserDefaults] integerForKey:STMODE_KEY];
    
    self.fileManager = [NSFileManager defaultManager];
    
    NSArray *urls = [self.fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    
    NSArray *defaultsAsArray = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] allValues];
  
    
    self.userURL = urls[0];
    self.myFileURL = [self.userURL URLByAppendingPathComponent:@"stroopResultsFile"];
    
    
    [defaultsAsArray writeToURL:self.myFileURL atomically:YES];
    
    
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
    uint currentScore = self.stroopTest.currentScore;
    
    //warning!  You must set duration and score in this order
   self.testResult.duration = duration;
    self.testResult.score = self.stroopTest.currentScore;
    self.testResult = nil;
    
    int currentMode = [[NSUserDefaults standardUserDefaults] integerForKey:STMODE_KEY];
    
    if (currentMode==0) {
    
   //     self.STCorrectScoreLabel.text = [[NSString alloc] initWithFormat:@"Latest Result=%d",self.stroopTest.currentScore];
        if (duration>0.1){
            self.elapsedSecondsLabel.text = [[NSString alloc] initWithFormat:@"Seconds: %.2f",duration];
        }
    }
    else {self.elapsedSecondsLabel.text = [[NSString alloc] initWithFormat:@"Score: %d",currentScore];
        
    }
    
    [[[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] allValues] writeToURL:self.myFileURL atomically:YES];
    
}

- (void) StroopTestScorePlusOne
{
    self.stroopTest.currentScore++;
   //     self.STCorrectScoreLabel.text = [[NSString alloc] initWithFormat:@"Score: %d",self.stroopTest.currentScore];
  
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
    self.elapsedSecondsLabel.text = [[NSString alloc] initWithFormat:@"Cancelled"];
    
}



- (STScores *) testResult
{
    if (!_testResult) _testResult = [[STScores alloc] init];
    return _testResult;
}


- (IBAction)InstructionsButtonPressed:(id)sender {
    
    UIViewController *instructionsVC = [self.storyboard instantiateViewControllerWithIdentifier:(@"instructionsNavController")];
    
    [self.navigationController pushViewController:instructionsVC animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
    
    if ([segue.identifier isEqualToString:@"gotoSceneVC"]){
        self.nextView = [segue destinationViewController];
        
        STScene *startingScene = [[STScene alloc] init];
        
        self.stroopTest = [[STTest alloc] init];
        
        self.stroopTest.latestScene = startingScene;
        
        
        self.nextView.scene = self.stroopTest.latestScene;
        self.nextView.delegate = self;
    }
    else
        NSLog(@"segue=%@",segue.identifier);
    
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
    self.elapsedSecondsLabel.text = @" ";
  //  self.STCorrectScoreLabel.text = @" ";
    
    [self initializeSettingsIfNecessary];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

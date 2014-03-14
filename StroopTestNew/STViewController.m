//
//  STViewController.m
//  StroopTestNew
//
//  Created by Richard Sprague on 3/26/13.
//  Copyright (c) 2013 Richard Sprague. All rights reserved.
//

#import "STViewController.h"
#import "STTest.h"
#import "ZBConnectionDelegate.h"
#import "StroopData.h" // the Core Data store


@interface STViewController ()<STSceneProtocol>
@property (weak, nonatomic) IBOutlet UILabel *elapsedSecondsLabel;
//@property (weak, nonatomic) IBOutlet UILabel *STCorrectScoreLabel;
@property (strong, nonatomic) STScores *testResult;
@property (strong, nonatomic) STTest *stroopTest;
@property (strong, nonatomic) STSceneVC *nextView;
@property (strong, nonatomic) NSTimer *timerForTest;

@property (strong, nonatomic) ZBConnectionDelegate *ZBConnection;

@property (strong, nonatomic) NSManagedObjectContext *context;


@property NSFileManager *fileManager;
@property NSURL *userURL;
@property NSURL *myFileURL;

@end

@implementation STViewController

@synthesize stroopTest = _stroopTest;

- (ZBConnectionDelegate *) getZBConnection{
    if (!self.ZBConnection) { self.ZBConnection = [[ZBConnectionDelegate alloc] init];}
    
    return self.ZBConnection;
}

- (void) initializeSettingsIfNecessary
{
   // int STMode = [[NSUserDefaults standardUserDefaults] integerForKey:STMODE_KEY];
  
    

    
    self.fileManager = [NSFileManager defaultManager];
    
    NSArray *urls = [self.fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    
  //  NSArray *defaultsAsArray = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] allValues];
  
    
    self.userURL = urls[0];
    self.myFileURL = [self.userURL URLByAppendingPathComponent:@"stroopResultsFile"];
    
 // writes the current defaults to the disk on setup.  Not particularly useful, I guess, unless somehow the current disk file was missing or corrupted.
    // Instead, this should READ from the disk and put the results into NSDefault
    
    
 //   [defaultsAsArray writeToURL:self.myFileURL atomically:YES];

    NSString *textToWrite = [[NSString alloc] initWithFormat:@"date,%@,score,%d,duration,%f,\n",[NSDate date], 0,0.0];
    NSError *err;
    
    bool success = [textToWrite writeToURL:self.myFileURL atomically:YES encoding: NSUnicodeStringEncoding error:&err];
    if (!success) {
        NSLog(@"Error on first write: %@",err.description);
    }
    

    
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



- (void) ZBAddNewEvent {
    
    NSLog(@"Added new event to Zenobase and returned: %@",self.ZBConnection.ZBJsonResults);
    
}

- (void) STAddNewEvent {
    
    
}

- (void) STUpdateScore
{
    NSTimeInterval duration = self.stroopTest.elapsedTime;
    uint currentScore = self.stroopTest.currentScore;

    
    //warning!  You must set duration and score in this order
    
  // the act of initalizing testResult saves it to NSUserDefaults
//   self.testResult.duration = duration;
//    
//    
//    self.testResult.score = self.stroopTest.currentScore;
//    self.testResult = nil;
    
    NSInteger currentMode = [[NSUserDefaults standardUserDefaults] integerForKey:STMODE_KEY];
    
    NSManagedObjectContext *localContext = [self managedObjectContext];
    
    if (!localContext)
    {NSLog(@"No context!  Problem updating score");}
    else
    {
        StroopData *thisScore = [NSEntityDescription insertNewObjectForEntityForName:@"StroopData" inManagedObjectContext:localContext];
        
        if (!thisScore) { NSLog(@"no StroopData entity found");
            
        }
        else {
            thisScore.duration= [NSNumber numberWithDouble:duration];
        thisScore.score = [NSNumber numberWithInt:currentScore];
        thisScore.date = [NSDate date];
        
        
        thisScore.playMode =  [NSNumber numberWithInteger:currentMode];
        }
    }
    

    
 
    
    
    if (currentMode==0) {
    
   //     self.STCorrectScoreLabel.text = [[NSString alloc] initWithFormat:@"Latest Result=%d",self.stroopTest.currentScore];
        if (duration>0.1){
            self.elapsedSecondsLabel.text = [[NSString alloc] initWithFormat:@"Seconds: %.2f",duration];
        }
    }
    else {self.elapsedSecondsLabel.text = [[NSString alloc] initWithFormat:@"Score: %d",currentScore];
        
    }
    
    // we save the entire defaults file to disk every time we update the score.  Not the most efficient design ever.
    // This should update it incremently to disk.
    
   // [[[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] allValues] writeToURL:self.myFileURL atomically:YES];
    
    NSError *err;
    NSString *contents = [NSString stringWithContentsOfURL:self.myFileURL encoding: NSUnicodeStringEncoding error:&err];
    NSString *textToWrite = [[NSString alloc] initWithFormat:@"date,%@,score,%d,duration,%f,\n",[NSDate date], currentScore,duration];
    contents = [contents stringByAppendingString:textToWrite];
    bool success = [contents writeToURL:self.myFileURL atomically:YES encoding: NSUnicodeStringEncoding error:&err];
    if (!success) {
        NSLog(@"Error %@ writing to file", err);
        
    }
    
    
        self.ZBConnection = [[ZBConnectionDelegate alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ZBAddNewEvent) name:RECEIVED_JSON_FROM_ZENOBASE object:nil];
    
    NSDictionary *newScore = @{
                               @"count" : [NSNumber numberWithInt:currentScore] ,
                              @"duration": [NSNumber numberWithFloat:duration]};
    
    
    
  //  NSString *ScoreLabel = [[NSString alloc] initWithFormat:@"%d",currentScore];
    
 //   NSDictionary *newScore = [NSDictionary dictionaryWithObjectsAndKeys:[[NSNumber alloc] initWithInt:currentScore],@"count",nil];
    
    NSString *newEventLabel =[[NSUserDefaults standardUserDefaults]
                              objectForKey: ST_ID_IN_ZENOBASE];
    
    [self.ZBConnection addNewEventToBucket: newEventLabel
                                            withEvent:newScore];
    
}

// Increment the score and stop if you're at Max Score.
- (void) StroopTestScorePlusOne
{
    self.stroopTest.currentScore++;
   //     self.STCorrectScoreLabel.text = [[NSString alloc] initWithFormat:@"Score: %d",self.stroopTest.currentScore];
  
        NSInteger userDefaultNumTests;
    userDefaultNumTests = [[NSUserDefaults standardUserDefaults] integerForKey:STMAXSCORE_KEY];
    
    
    if (userDefaultNumTests==0) userDefaultNumTests=3;

    
    NSInteger STMode = [[NSUserDefaults standardUserDefaults] integerForKey:STMODE_KEY];
    
    
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

    
    NSInteger STMode = [[NSUserDefaults standardUserDefaults] integerForKey:STMODE_KEY];

    
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

// simple action method so the instructions can unwind back to this, the main screen

- (IBAction) unwindToMainMenu: (UIStoryboardSegue*)sender {
    
}

- (NSManagedObjectContext *) managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]){
        context = [delegate managedObjectContext];
    }
    
    return context;
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

- (void) viewDidAppear:(BOOL)animated {
    

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.context = [self managedObjectContext];
    
    if (!self.context) {NSLog(@"serious error: no context found on app launch");}
        
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

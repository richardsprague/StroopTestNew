//
//  STViewController.m
//  StroopTestNew
//
//  Created by Richard Sprague on 3/26/13.
//  Copyright (c) 2013 Richard Sprague. All rights reserved.
//

#import "STViewController.h"
#import "STTest.h"
//#import "ZBConnectionDelegate.h"  //Zenobase support deleted from current version
#import "StroopData.h" // the Core Data store


@interface STViewController ()<STSceneProtocol>
@property (weak, nonatomic) IBOutlet UILabel *elapsedSecondsLabel;
//@property (weak, nonatomic) IBOutlet UILabel *STCorrectScoreLabel;
//@property (strong, nonatomic) STScores *testResult;
@property (strong, nonatomic) STTest *stroopTest;
@property (strong, nonatomic) STSceneVC *nextView;
@property (strong, nonatomic) NSTimer *timerForTest;

// Zenobase support is deleted from current version
//@property (strong, nonatomic) ZBConnectionDelegate *ZBConnection;

@property (strong, nonatomic) NSManagedObjectContext *context;




@end

@implementation STViewController

@synthesize stroopTest = _stroopTest;



/*
 // This section works but is deleted from current version (Zenobase)
- (ZBConnectionDelegate *) getZBConnection{
    if (!self.ZBConnection) { self.ZBConnection = [[ZBConnectionDelegate alloc] init];}
    
    return self.ZBConnection;
}
*/


-(NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"stroopResultsFile.csv"];
}

- (void) initializeSettingsIfNecessary
{
    
// you only do this once per user, because results are all stored in NSUserDefaults.  Just initialize this the very first time you launch the app.
    
    STSettings *OverallSettings = [[STSettings alloc] init ];
    if (!OverallSettings) { NSLog(@"problem initializing settings");}

//If the CSV file doesn't exist yet, create one and write a header row.
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self dataFilePath]]) {
        [[NSFileManager defaultManager] createFileAtPath: [self dataFilePath] contents:nil attributes:nil];
        NSLog(@"new results file created");
        NSString *textToWrite = [[NSString alloc] initWithFormat:@"date,score,duration,mode,comment\n"];
        NSFileHandle *handle;
        handle = [NSFileHandle fileHandleForWritingAtPath: [self dataFilePath] ];
        //say to handle where's the file fo write
 //       [handle truncateFileAtOffset:[handle seekToEndOfFile]];
        //position handle cursor to the end of file
        [handle writeData:[textToWrite dataUsingEncoding:NSUTF8StringEncoding]];
        
        
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

/*
 // Zenobase suport: this section works but is deleted from current version

- (void) ZBAddNewEvent {
    
    NSLog(@"Added new event to Zenobase and returned: %@",self.ZBConnection.ZBJsonResults);
    
}
 
*/

- (void) STAddNewEvent {
    
    
}

- (void) saveToDisk: (NSDate *) date score: (uint) currentScore duration: (NSTimeInterval) duration  mode: (uint) currentMode {
    
    NSString *textToWrite = [[NSString alloc] initWithFormat:@"%@,%d,%f,%d\n",[NSDate date], currentScore,duration,currentMode];
    NSFileHandle *handle;
    handle = [NSFileHandle fileHandleForWritingAtPath: [self dataFilePath] ];
    //say to handle where's the file fo write
    [handle truncateFileAtOffset:[handle seekToEndOfFile]];
    //position handle cursor to the end of file
    [handle writeData:[textToWrite dataUsingEncoding:NSUTF8StringEncoding]];
    
}

- (void) STUpdateScore
{
    NSTimeInterval duration = self.stroopTest.elapsedTime;
    uint currentScore = self.stroopTest.currentScore;

    

    
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
    
   //save the latest score to disk.
    // [self.saveToDisk date: score: duration: mode:
    
    [self saveToDisk:[NSDate date] score:currentScore duration:duration mode:(uint)currentMode];
    

/****
 // Zenobase support :: this section works but is deleted from current version.
    
        self.ZBConnection = [[ZBConnectionDelegate alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ZBAddNewEvent) name:RECEIVED_JSON_FROM_ZENOBASE object:nil];
    
    NSDictionary *newScore = @{
                               @"count" : [NSNumber numberWithInt:currentScore] ,
                              @"duration": [NSNumber numberWithFloat:duration]};
    
    
    
    NSString *newEventLabel =[[NSUserDefaults standardUserDefaults]
                              objectForKey: ST_ID_IN_ZENOBASE];
    
   [self.ZBConnection addNewEventToBucket: newEventLabel withEvent:newScore];
 
****/
    
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


/* deprecated on 5/8/15
- (STScores *) testResult
{
    if (!_testResult) _testResult = [[STScores alloc] init];
    return _testResult;
}
*/

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
    
    [super viewDidAppear:animated];
    
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

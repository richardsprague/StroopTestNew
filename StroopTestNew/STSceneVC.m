//
//  STSceneVC.m
//  StroopTestNew
//
//  Created by Richard Sprague on 3/26/13.
//  Copyright (c) 2013 Richard Sprague. All rights reserved.
//

#import "STSceneVC.h"
#import "STCardView.h"
#import "STSelectionsView.h"
#import "STScores.h"

@interface STSceneVC ()// <STSceneProtocol>


@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *STSelectionButtons;

@property (weak, nonatomic) IBOutlet UILabel *STSecsLabel;
@property (weak, nonatomic) IBOutlet STCardView *STCardForCurrentScene;
@property (strong, nonatomic) STScene *currentScene;
@property (strong, nonatomic) NSDate *startTime;
@property (weak, nonatomic) IBOutlet UILabel *STLatestScoreLabel;
@property (nonatomic) uint latestScore;
@property (nonatomic) float elapsedTime;
@property (strong, nonatomic) STScores *testResult;
@property uint numAttempts;
@property (weak, nonatomic) IBOutlet UILabel *STModeLabel;

@end

@implementation  STSceneVC

- (IBAction)STSceneClickCancel:(UIButton *)sender {
    
    [self.delegate StroopTestScore:0];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (STScores *) testResult
{
    if (!_testResult) _testResult = [[STScores alloc] init];
    return _testResult;
}

- ( void)  StroopTestScore: (uint)  finalTestScore
{
    
}

- ( void)  ElapsedTimeInSeconds: (float)StroopTestElapsedTime
{
    
}

- (STScene *) currentScene
{
    if (!_currentScene) _currentScene = [[STScene alloc] init];
    return _currentScene;
}


- (IBAction)STSelectionButtons:(id)sender {

    uint userDefaultNumTests;
    uint thisButton = [self.STSelectionButtons indexOfObject:sender];
    
    
    NSArray *aColor = self.currentScene.card.shuffledColors[thisButton];
    
    if (self.currentScene.card.color == aColor[0]) self.latestScore++;
    
    
    
    [self.delegate StroopTestScore:self.currentScene.latestScore];
    [self.delegate ElapsedTimeInSeconds:-[self.startTime timeIntervalSinceNow]];
    
    userDefaultNumTests = [[NSUserDefaults standardUserDefaults] integerForKey:STMAXSCORE_KEY];
    
        
        if (userDefaultNumTests==0) userDefaultNumTests=3;
        self.numAttempts++;
    
int STMode = [[NSUserDefaults standardUserDefaults] integerForKey:STMODE_KEY];
    
    
    if (!STMode) {   // STMode=0 means continue to max score
        if (self.latestScore>=userDefaultNumTests){
            self.testResult.score = self.numAttempts;
            
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    
    self.currentScene = nil;
    
    [self showScene];
    
    //   NSLog(@"button=%d",thisButton);
}

- (void) showScene
{
    [self showCard];
    [self showSelectionButtons];
    self.STLatestScoreLabel.text = [[NSString alloc] initWithFormat:@"%d",self.latestScore];
    
}

- (void) showCard
{
    //self.STCardView.backgroundColor = self.scene.card.color;
    [self.STCardForCurrentScene showCard:self.currentScene.card];
   

}

- (void) showSelectionButtons
{
    
   // [self.STSelectionButtons showButtons:self.currentScene.selections];
    
    
    for (int i = 0 ; i < [self.STSelectionButtons count] ; i++){
        UIButton *aButton = self.STSelectionButtons[i];
        NSArray *aColor = self.currentScene.card.shuffledColors[i];
        
     
        
        NSString *buttonLabel = [[NSString alloc] initWithFormat:@"%@", aColor[1]];
        [aButton setTitle:buttonLabel forState:UIControlStateNormal];
        
        
        [aButton setTitleColor:[[[STColors alloc] init] randomUIColor] forState:UIControlStateNormal];
        [aButton setBackgroundColor:[[[STColors alloc] init] randomUIColor]];
    }
    
}

- (void) STSecondsPassed
{
    self.STSecsLabel.text = [[NSString alloc] initWithFormat:@"%d",-(int)[self.startTime timeIntervalSinceNow]];
}

- (void) STTimeExpired
{
  //  NSLog(@"time expired after %f sec",-[self.startTime timeIntervalSinceNow]);
    self.testResult.score = self.numAttempts;
    
    [self.delegate StroopTestScore:self.numAttempts];
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
    if (!self.currentScene){
        self.currentScene  = [[STScene alloc] init];
    }
    
   // + (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds invocation:(NSInvocation *)invocation repeats:(BOOL)repeats
    
    self.STModeLabel.text = [[NSString alloc] initWithFormat:@"mode:%d",[[NSUserDefaults standardUserDefaults] integerForKey:STMODE_KEY]];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(STSecondsPassed) userInfo:nil repeats:YES];
    
    int STMode = [[NSUserDefaults standardUserDefaults] integerForKey:STMODE_KEY];
    self.STModeLabel.text = [[NSString alloc] initWithFormat:@"mode:%d",STMode];
    
    if (!(STMode==0)) {
        
        //        if (STMode==1) {
        //
        //        [NSTimer scheduledTimerWithTimeInterval: 15.0 target:self selector:@selector(STTimeExpired) userInfo:nil repeats:NO];
        //        } else if (STMode == 2) {
        //                  [NSTimer scheduledTimerWithTimeInterval: 30.0 target:self selector:@selector(STTimeExpired) userInfo:nil repeats:NO];
        //        } else if (STMode == 3) {
        //                  [NSTimer scheduledTimerWithTimeInterval: 60.0 target:self selector:@selector(STTimeExpired) userInfo:nil repeats:NO];
        //        }
        
        switch (STMode) {
            case 1:
                [NSTimer scheduledTimerWithTimeInterval: 15.0 target:self selector:@selector(STTimeExpired) userInfo:nil repeats:NO];
                break;
            case 2:
                [NSTimer scheduledTimerWithTimeInterval: 30.0 target:self selector:@selector(STTimeExpired) userInfo:nil repeats:NO];
                break;
            case 3:
                [NSTimer scheduledTimerWithTimeInterval: 60.0 target:self selector:@selector(STTimeExpired) userInfo:nil repeats:NO];
                break;
                
            default: NSLog(@"unknown STMode");
                break;
        }
        
    }
    
    self.startTime = [[NSDate alloc] init];
    self.testResult.score   = 0;
    self.numAttempts = 0;
    [self showScene];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

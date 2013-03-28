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
#import "STSettingsVC.h"
#import "STScores.h"

@interface STSceneVC ()<STSceneProtocol>


@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *STSelectionButtons;

@property (weak, nonatomic) IBOutlet STCardView *STCardForCurrentScene;
@property (strong, nonatomic) STScene *currentScene;
@property (strong, nonatomic) NSDate *startTime;
@property (nonatomic) uint latestScore;
@property (nonatomic) float elapsedTime;
@property (strong, nonatomic) STScores *testResult;
@property uint numAttempts;

@end

@implementation  STSceneVC

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
    
    if (self.latestScore>=userDefaultNumTests){
        self.testResult.score = self.numAttempts;
        
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    
    self.currentScene = nil;
    
    [self showScene];
    
    //   NSLog(@"button=%d",thisButton);
}

- (void) showScene
{
    [self showCard];
    [self showSelectionButtons];
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
    }
    
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
    self.startTime = [[NSDate alloc] init];
    self.testResult.score   = 0;
    [self showScene];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

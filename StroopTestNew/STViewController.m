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
@property (strong, nonatomic) STTest *stroopTest;

@end

@implementation STViewController

@synthesize stroopTest = _stroopTest;

- (void) initializeSettingsIfNecessary
{
   // int STMode = [[NSUserDefaults standardUserDefaults] integerForKey:STMODE_KEY];
    
}

- (void) setStroopTest:(STTest *)stroopTest
{
    if (!_stroopTest) _stroopTest = [[STTest alloc] init];
    else _stroopTest = stroopTest;
    
}

- (STTest *) stroopTest
{
    
    if (!self.stroopTest) {
        self.stroopTest = [[STTest alloc] init];
    }
    return self.stroopTest;
    
}

- ( void)  StroopTestScore: (uint) finalTestScore
{
    if(finalTestScore>0) {
        
    self.STCorrectScoreLabel.text = [[NSString alloc] initWithFormat:@"Correct: %d",finalTestScore];
    }
    
}
- (IBAction)startTestButtonPressed:(id)sender {

    
}

- ( void)  ElapsedTimeInSeconds: (float) StroopTestElapsedTime
{
    if (StroopTestElapsedTime>0.1) {self.elapsedSecondsLabel.text = [[NSString alloc] initWithFormat:@"Seconds: %f",StroopTestElapsedTime];
    }
    
}
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    STSceneVC *nextView = [segue destinationViewController];
    
    STScene *startingScene = [[STScene alloc] init];
    
    self.stroopTest = [[STTest alloc] initTestWithScene:startingScene];
    

 //   nextView.scene = [self.stroopTest currentScene];
    nextView.delegate = self;
    
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

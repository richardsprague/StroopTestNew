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

@interface STSceneVC ()


@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *STSelectionButtons;

@property (weak, nonatomic) IBOutlet UILabel *STSecsLabel;
@property (weak, nonatomic) IBOutlet STCardView *STCardForCurrentScene;

@property (strong, nonatomic) NSDate *startTime;
@property (weak, nonatomic) IBOutlet UILabel *STLatestScoreLabel;
@property (nonatomic) uint latestScore;
//@property (nonatomic) float elapsedTime;

@property (weak, nonatomic) IBOutlet UILabel *STModeLabel;

@end

@implementation  STSceneVC

- (IBAction)STSceneClickCancel:(UIButton *)sender {
    
    [self.delegate cancelTest];
    [self dismissViewControllerAnimated:YES completion:nil];
}





- (IBAction)STSelectionButtons:(id)sender {

    
    uint thisButton = [self.STSelectionButtons indexOfObject:sender];
    
    
    NSArray *aColor = self.scene.card.shuffledColors[thisButton];
    
    if (self.scene.card.color == aColor[0]){
       self.latestScore++;
        [self.delegate StroopTestScorePlusOne];
        
    }
    

    self.scene = [[STScene alloc] init ];
    
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
  
    [self.STCardForCurrentScene showCard:self.scene.card];
   
    
   
}

- (void) showSelectionButtons
{
        
    
    for (int i = 0 ; i < [self.STSelectionButtons count] ; i++){
        UIButton *aButton = self.STSelectionButtons[i];
        NSArray *aColor = self.scene.card.shuffledColors[i];
        
     
        
        NSString *buttonLabel = [[NSString alloc] initWithFormat:@"%@", aColor[1]];
        [aButton setTitle:buttonLabel forState:UIControlStateNormal];
        
        
        [aButton setTitleColor:[[[STColors alloc] init] randomUIColor] forState:UIControlStateNormal];
        [aButton setTitleShadowColor:[[[STColors alloc] init] randomUIColor] forState:UIControlStateNormal];
    }
    
}

- (void) STSecondsPassed
{
    self.STSecsLabel.text = [[NSString alloc] initWithFormat:@"%d",-(int)[self.startTime timeIntervalSinceNow]];
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

    assert(self.scene); // the scene had better have been created before getting here.
    
    
    self.STModeLabel.text = [[NSString alloc] initWithFormat:@"mode:%d",[[NSUserDefaults standardUserDefaults] integerForKey:STMODE_KEY]];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(STSecondsPassed) userInfo:nil repeats:YES];
    
    int STMode = [[NSUserDefaults standardUserDefaults] integerForKey:STMODE_KEY];
    self.STModeLabel.text = [[NSString alloc] initWithFormat:@"mode:%d",STMode];
    
    self.startTime = [[NSDate alloc] init];

    [self showScene];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

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
//#import "STScores.h"

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

    
    NSUInteger thisButton = [self.STSelectionButtons indexOfObject:sender];
    
    
    NSArray *aColor = [[NSArray alloc] initWithArray:self.scene.card.shuffledColors[thisButton]];
    
    
 //   NSLog(@"card color=%@", self.scene.card.color.colorNameAsString);
//    NSLog(@"tapped color=%@", aColor[1]);
    
  //  if ([self.scene.card.color isMatch: aColor[0]]){
    if (self.scene.card.color.colorNameAsString == aColor[1]){
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

// of the five buttons, I need to turn on exactly three.
// 1. the far left button or the second to the left (randomly)
// 2. the far right button or the second to the right (randomly)
// 3. the middle button or the one to either side, depending on which were chosen above
- (void) showSelectionButtons
{
    

    NSArray *shuffledColorArray = [STCard shuffledColorArray];
    
    
    // walk through the buttons
    for (int j = 0 ; j < [self.STSelectionButtons count] ; j++){
 //   for (UIButton *aButton in self.STSelectionButtons){
        
        int i  = j ; // the index that aButton has in self.STSelectionButtons
        
        UIButton *aButton = self.STSelectionButtons[i];
        NSArray *aColor = self.scene.card.shuffledColors[i];
        //assign each
     
        //the button label will be a string name for the color in the shuffled color array
        NSString *buttonLabel = [[NSString alloc] initWithFormat:@"%@", aColor[1]];
        [aButton setTitle:buttonLabel forState:UIControlStateNormal];
       
        //but the color of the label will be chosen from the random shuffledColorArray above
       [aButton setTitleColor:shuffledColorArray[i][0] forState:UIControlStateNormal];
       [aButton setTitleShadowColor:shuffledColorArray[i][0] forState:UIControlStateNormal];

        
    }
    
}
// OLD CODE:
// walk through the buttons
//   for (int j = 0 ; j < [self.STSelectionButtons count] ; j++){
//for (UIButton *aButton in self.STSelectionButtons){
//    
//    int i  = j % 3;
//    
//    //UIButton *aButton = self.STSelectionButtons[i];
//    NSArray *aColor = self.scene.card.shuffledColors[i];
//    //assign each
//    
//    
//    NSString *buttonLabel = [[NSString alloc] initWithFormat:@"%@", aColor[1]];
//    [aButton setTitle:buttonLabel forState:UIControlStateNormal];
//    
//    
//    [aButton setTitleColor:shuffledColorArray[i][0] forState:UIControlStateNormal];
//    [aButton setTitleShadowColor:shuffledColorArray[i][0] forState:UIControlStateNormal];
//    
//    
//}


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
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:STMODE_KEY]==0) {
        self.STModeLabel.text = [[NSString alloc] initWithFormat:@"%@",@"score"];
    } else self.STModeLabel.text = [[NSString alloc] initWithFormat:@"%@",@"time"];
    
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(STSecondsPassed) userInfo:nil repeats:YES];
    
//    int STMode = [[NSUserDefaults standardUserDefaults] integerForKey:STMODE_KEY];
//    self.STModeLabel.text = [[NSString alloc] initWithFormat:@"mode:%d",STMode];
    
    self.startTime = [[NSDate alloc] init];

    [self showScene];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

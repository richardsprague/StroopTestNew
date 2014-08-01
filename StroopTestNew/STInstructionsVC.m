//
//  STInstructionsVC.m
//  StroopTestNew
//
//  Created by Richard Sprague on 7/31/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import "STInstructionsVC.h"
#import "STCardView.h"

@interface STInstructionsVC ()

@property (weak, nonatomic) IBOutlet UILabel *instructionsLabel;
@property (weak, nonatomic) IBOutlet UIView *instructionsCardViewPlaceholder;
@property  (strong, nonatomic) IBOutletCollection(UIButton) NSArray *instructionsSampleLabels;

@property (strong, nonatomic)STCardView *instructionsCardView;
@property (strong, nonatomic) STCard *instructionsSampleCard;
@property (weak, nonatomic) IBOutlet UILabel *instructionsCardDescriptionLabel;

@property (weak, nonatomic) IBOutlet UILabel *instructionsLabelForCardColor;


@end

@implementation STInstructionsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) showInstructionsSampleButtonLabels
{
    
    
    for (int i = 0 ; i < [self.instructionsSampleLabels count] ; i++){
        UIButton *aButton = self.instructionsSampleLabels[i];
        NSArray *aColor = self.instructionsSampleCard.shuffledColors[i];
        
      
        
 //  NSArray *aColor = self.scene.card.shuffledColors[i];
        
        NSString *buttonLabel = [[NSString alloc] initWithFormat:@"%@", aColor[1]];
        [aButton setTitle:buttonLabel forState:UIControlStateNormal];
        
        
        [aButton setTitleColor:[[[STColors alloc] init] randomUIColor] forState:UIControlStateNormal];
        [aButton setTitleShadowColor:[[[STColors alloc] init] randomUIColor] forState:UIControlStateNormal];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   
     self.instructionsSampleCard = [[STCard alloc ]init];
    
    self.instructionsCardView = [[STCardView alloc] initWithFrame:self.instructionsCardViewPlaceholder.frame];
    
    [self.view addSubview:self.instructionsCardView];
    [self.instructionsCardViewPlaceholder removeFromSuperview];
    
    // WithCard:self.instructionsSampleCard];
    self.instructionsCardView.cardColor = self.instructionsSampleCard.color;
    
    
    [self.instructionsCardView showCard:self.instructionsSampleCard];
    
    self.instructionsLabel.text =[[NSString alloc] initWithFormat:@"Tap the logo to start, then match the color of the card with its name as quickly as you can. For example, this is a %@ card", [STColors colorAsString:self.instructionsCardView.cardColor]];
    self.instructionsLabelForCardColor.text = [[NSString alloc] initWithFormat:@"\"%@\"", [STColors colorAsString:self.instructionsCardView.cardColor]];
    
   // self.instructionsLabel.text = @"Tap the logo to start, then match the color of the card with its name as quickly as you can. For example, this is a ";
    
    [self showInstructionsSampleButtonLabels];
    
    
    
    //self.instructionsCardViewPlaceholder=self.instructionsCardView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

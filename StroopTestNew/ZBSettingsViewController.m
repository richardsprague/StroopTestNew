//
//  ZBSettingsViewController.m
//  ZenobaseViewer
//
//  Created by Richard Sprague on 2/25/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import "ZBSettingsViewController.h"
#import "STSettings.h"

@interface ZBSettingsViewController () <UITextFieldDelegate> // <ZBConnectionProtocol>

@property (strong, nonatomic) NSString *ZBUsernameString;
@property (strong, nonatomic) NSString *ZBPasswordString;

@property (strong, nonatomic) NSString *ZBAccessTokenString;
@property (strong, nonatomic) NSString *ZBClientIDString;
@property (strong, nonatomic) ZBConnectionDelegate *ZBConnection;


@property (strong, nonatomic) NSMutableArray *AllBuckets;


@property (weak, nonatomic) IBOutlet UITextField *ZBUsernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *ZBPasswordTextField;
@property (weak, nonatomic) IBOutlet UILabel *ZBAccessTokenLabel;

@property (weak, nonatomic) IBOutlet UILabel *ZBUserNameLabel;




@end

@implementation ZBSettingsViewController

//- (void)didReceiveJSON:(NSDictionary*)json
//{
//    self.ZBAccessTokenString = [json objectForKey:@"access_token"];
//    self.ZBClientIDString = [json objectForKey:@"client_id"];
//    
//    self.ZBAccessTokenLabel.text = self.ZBAccessTokenString;
//    
//    [[NSUserDefaults standardUserDefaults] setObject:self.ZBAccessTokenString forKey:ZBACCESSTOKEN_KEY];
//    [[NSUserDefaults standardUserDefaults] setObject:self.ZBClientIDString forKey:ZBCLIENTID_KEY];
//}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void) gotTokenStrings {
    
    
    self.ZBAccessTokenString = [self.ZBConnection.ZBJsonResults objectForKey:@"access_token"];
    self.ZBClientIDString = [self.ZBConnection.ZBJsonResults objectForKey:@"client_id"];
    
    self.ZBAccessTokenLabel.text = self.ZBAccessTokenString;
    
    [[NSUserDefaults standardUserDefaults] setObject:self.ZBAccessTokenString forKey:ZBACCESSTOKEN_KEY];
    [[NSUserDefaults standardUserDefaults] setObject:self.ZBClientIDString forKey:ZBCLIENTID_KEY];
    
 //   [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void) gotBuckets {
    
    
    NSDictionary *jsonBuckets = [self.ZBConnection.ZBJsonResults objectForKey:@"buckets"];
    NSString *stroopID = nil;
    NSMutableArray *bucketArray = [[NSMutableArray alloc] init];
    for (NSDictionary *bucket in jsonBuckets ){
        [bucketArray addObject:bucket];
        if([[bucket objectForKey:@"label"] isEqualToString:@"Stroop"]) {
            stroopID = [bucket objectForKey:@"@id"];
            NSLog(@"found stroop label, ID=%@",stroopID);
            
        }
    }
    
    if (!stroopID) {NSLog(@"no stroop item found in Zenobase");}
    
    [[NSUserDefaults standardUserDefaults]  setObject:stroopID forKey:ST_ID_IN_ZENOBASE];

    
    // NSLog(bucketArray.description);
    NSMutableArray *bucketsTemp = [[NSMutableArray alloc] init];
    
    for (NSDictionary *bucket in bucketArray){
   //     NSLog(@"bucket=%@",[bucket objectForKey:@"label"]);
        [bucketsTemp addObject:[bucket objectForKey:@"label"]];
    }
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


- (IBAction)clickGetStroopID:(id)sender {
    
    ZBConnectionDelegate *bucketsConnection = [[ZBConnectionDelegate alloc] init ];
    self.ZBConnection = bucketsConnection;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotBuckets) name:RECEIVED_JSON_FROM_ZENOBASE object:nil];
    [self.ZBConnection getBuckets];
    
}

- (void) getBucketIDForStroop {
    


    
}

- (IBAction)clickSubmit:(id)sender {
    ZBConnectionDelegate *newConnection = [[ZBConnectionDelegate alloc] init ];
    self.ZBConnection = newConnection;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotTokenStrings) name:RECEIVED_JSON_FROM_ZENOBASE object:nil];
//    newConnection.delegate = self;
    
    [newConnection getZBAccessTokenForUsername:self.ZBUsernameString withPassword:self.ZBPasswordString];
    
    [sender resignFirstResponder];
    NSLog(@"finished submit");
    
    
   
    
    //  self.ZBUserNameLabel.text = [[NSString alloc] initWithString:newConnection.ZBAccessToken];
    
}

- (IBAction)clickUsername:(UITextField *)sender {
    
    self.ZBUsernameString = [[NSString alloc] initWithString: self.ZBUsernameTextField.text];
    self.ZBUserNameLabel.text = self.ZBUsernameString;
    
    [[NSUserDefaults standardUserDefaults] setObject:self.ZBUsernameString  forKey:ZBUSERNAME_KEY ];
    self.ZBUserNameLabel.text = self.ZBUsernameString;
}

- (IBAction)clickPassword:(UITextField *)sender {
    self.ZBPasswordString = [[NSString alloc] initWithString: self.ZBPasswordTextField.text];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:self.ZBPasswordString  forKey:ZBPASSWORD_KEY ];
    
    
    
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
    
    // NB: assumes that if there is a valid username, then there's a valid password too.
    
    NSString *currentUsername = [[NSUserDefaults standardUserDefaults] stringForKey:ZBUSERNAME_KEY];
    
    // so the keyboard will disappear when you hit return.
    
    self.ZBUsernameTextField.delegate = self;
    self.ZBPasswordTextField.delegate =self;
    
    if (!currentUsername) {self.ZBUserNameLabel.text = @"<unknown>";
        
    } else {
        self.ZBUserNameLabel.text = currentUsername;
        self.ZBUsernameString = [[NSUserDefaults standardUserDefaults] stringForKey:ZBUSERNAME_KEY];
        self.ZBPasswordString = [[NSUserDefaults standardUserDefaults] stringForKey:ZBPASSWORD_KEY];
        
        
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

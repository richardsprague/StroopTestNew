//
//  ZBSettingsViewController.h
//  ZenobaseViewer
//
//  Created by Richard Sprague on 2/25/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//
// This view controller integrates the setup process.
// If there is already a username in the NSUserDefaults,
// then it assumes there's a username/password there too.
//
// If you enter a (new) username/password in the input text fields,
// then hit "update token" and the clickSubmit method gets called.
// clickSubmit opens a connection to Zenobase and brings back an access token, which is displayed on the screen.





#import <UIKit/UIKit.h>
#import "ZBConnectionDelegate.h"

@interface ZBSettingsViewController : UIViewController

@end

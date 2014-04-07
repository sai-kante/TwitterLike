//
//  HomeViewController.h
//  TwitterLike
//
//  Created by Sai Kante on 4/6/14.
//  Copyright (c) 2014 saiPersonal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsViewController.h"
#import "HomeTimeLineTableViewController.h"

@interface HomeViewController : UIViewController <SettingsViewControllerDelegate,HomeTimeLineViewControllerDelegate>

@property (retain, nonatomic) NSMutableArray *tweets;
- (void) homeButtonClicked;
- (void) mentionsButtonClicked;
- (void) logoutButtonClicked;

@end

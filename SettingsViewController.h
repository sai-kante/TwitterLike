//
//  SettingsViewController.h
//  TwitterLike
//
//  Created by Sai Kante on 4/6/14.
//  Copyright (c) 2014 saiPersonal. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsViewControllerDelegate <NSObject>

- (void) homeButtonClicked;
- (void) mentionsButtonClicked;

@end

@interface SettingsViewController : UIViewController

@property(weak,nonatomic) id<SettingsViewControllerDelegate> delegate;
- (void)updateContent;

@end

//
//  ProfileViewController.h
//  TwitterLike
//
//  Created by Sai Kante on 4/7/14.
//  Copyright (c) 2014 saiPersonal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface ProfileViewController : UIViewController <UIScrollViewDelegate>

@property (retain, nonatomic) User *user;

@end

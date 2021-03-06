//
//  TweetInDetailViewController.h
//  TwitterLike
//
//  Created by Sai Kante on 3/29/14.
//  Copyright (c) 2014 saiPersonal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "TweetComposeViewController.h"

@interface TweetInDetailViewController : UIViewController<TweetComposeViewControllerDelegate>

@property (retain, nonatomic) Tweet *currentTweet;

@end

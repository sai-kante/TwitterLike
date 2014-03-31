//
//  TweetComposeViewController.h
//  TwitterLike
//
//  Created by Sai Kante on 3/30/14.
//  Copyright (c) 2014 saiPersonal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"


@protocol TweetComposeViewControllerDelegate <NSObject>

- (void)onCancel;
- (void)onTweet:(Tweet *)tweet;

@end


@interface TweetComposeViewController : UIViewController<UITextViewDelegate>

@property(nonatomic,weak) id<TweetComposeViewControllerDelegate> delegate;
@property(nonatomic,strong) Tweet *currentTweet;

@end

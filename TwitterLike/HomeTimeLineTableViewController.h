//
//  HomeTimeLineTableViewController.h
//  TwitterLike
//
//  Created by Sai Kante on 3/29/14.
//  Copyright (c) 2014 saiPersonal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullRefreshTableViewController.h"
#import "TweetComposeViewController.h"

@protocol HomeTimeLineViewControllerDelegate <NSObject>

- (void) logoutButtonClicked;

@end

@interface HomeTimeLineTableViewController : PullRefreshTableViewController <UITableViewDataSource,UITableViewDelegate,TweetComposeViewControllerDelegate>

@property (retain, nonatomic) NSMutableArray *tweets;
@property(weak,nonatomic) id<HomeTimeLineViewControllerDelegate> delegate;


@end

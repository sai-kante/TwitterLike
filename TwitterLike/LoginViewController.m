//
//  LoginViewController.m
//  TwitterLike
//
//  Created by Sai Kante on 3/29/14.
//  Copyright (c) 2014 saiPersonal. All rights reserved.
//

#import "LoginViewController.h"
#import "HomeTimeLineTableViewController.h"
#import "TwitterClient.h"
#import "Tweet.h"
#import "HomeViewController.h"

@interface LoginViewController ()

- (IBAction)onLoginButton:(id)sender;
@end

@implementation LoginViewController

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
    self.title=@"Twitter Like";

    // auto login user if he is persisted
    TwitterClient *client=[TwitterClient instance];
    if([client isAuthorized]) {
        [client requestHomeTimelineWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSArray *tweets=(NSArray*)responseObject;
            [self loggedInWithTweets:tweets];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed to retrieve timeline with error : %@",error);
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLoginButton:(id)sender {
    [[TwitterClient instance] login];
}

- (void) loggedInWithTweets:(NSArray *)tweetsSourceArray {
    NSMutableArray *tweetsArray = [[NSMutableArray alloc] init];
    for(NSDictionary *tweetSrc in tweetsSourceArray) {
        Tweet *tweet= [[Tweet alloc] init];
        [tweet initTweetWithDictionary:tweetSrc];
        [tweetsArray addObject:tweet];
    }
    
    //initialize the HomeTimeLineTableViewController
    //HomeTimeLineTableViewController *homeTimeLine= [[HomeTimeLineTableViewController alloc] init];
    //homeTimeLine.tweets = tweetsArray;
    //[self.navigationController pushViewController:homeTimeLine animated:YES];
    HomeViewController *homeVC= [[HomeViewController alloc] init];
    homeVC.tweets = tweetsArray;
    [self.navigationController pushViewController:homeVC animated:YES];
}


@end

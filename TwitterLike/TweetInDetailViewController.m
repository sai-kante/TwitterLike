//
//  TweetInDetailViewController.m
//  TwitterLike
//
//  Created by Sai Kante on 3/29/14.
//  Copyright (c) 2014 saiPersonal. All rights reserved.
//

#import "TweetInDetailViewController.h"
#import "AFNetworking.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "User.h"
#import "TwitterClient.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface TweetInDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *reTweets;
@property (weak, nonatomic) IBOutlet UILabel *favorites;
@property (strong, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *reTweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *replyPostedLabel;
- (IBAction)onReplyClicked:(id)sender;
- (IBAction)onRetweetClicked:(id)sender;
- (IBAction)onFavoriteClicked:(id)sender;

@end

@implementation TweetInDetailViewController

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
    
    [super viewDidLoad];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.title=@"Tweet";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(onBackButton:)];
    [self.tweetText setLineBreakMode:NSLineBreakByWordWrapping];
    [self.tweetText setNumberOfLines:0];
    self.tweetText.text = self.currentTweet.tweetText;
    self.tweetText.preferredMaxLayoutWidth = CGRectGetWidth(self.view.bounds);
    [self.profileImage setImageWithURL:[NSURL URLWithString:self.currentTweet.profileImageUrl] placeholderImage:[UIImage imageNamed:@"noImage.png"]];
    [self.profileImage setRoundedCorners];
    self.screenName.text=[NSString stringWithFormat:@"@%@",self.currentTweet.screenName];
    self.reTweets.text= [NSString stringWithFormat:@"%@ RETWEETS",self.currentTweet.numberOfRetweets];
    self.favorites.text= [NSString stringWithFormat:@"%@ FAVORITES",self.currentTweet.numberOfFavorites];
    self.time.text=self.currentTweet.timeSince;
    self.userName.text=self.currentTweet.userName;
    self.replyPostedLabel.text=@"";
    [self.replyButton setImage:[UIImage imageNamed:@"reply"] forState:UIControlStateNormal];
    [self updateIcons];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)onReplyClicked:(id)sender {
    TweetComposeViewController *composeView= [[TweetComposeViewController alloc] init];
    composeView.delegate=self;
    composeView.currentTweet=self.currentTweet;
    
    [self presentViewController:composeView animated:YES completion:^{}];
}

- (IBAction)onRetweetClicked:(id)sender {
    
    if (!self.currentTweet.isRetweeted) {
        [[TwitterClient instance] retweetTweet:self.currentTweet withSuccess:^(AFHTTPRequestOperation *operation, id response) {
            self.currentTweet.isRetweeted=!self.currentTweet.isRetweeted;
            self.replyPostedLabel.text=@"Tweet posted";
            [self updateIcons];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Failed to retweet with error : %@",error);
        }];
    }
    else {
        NSLog(@"Already retweeted");
    }
    
}

- (IBAction)onFavoriteClicked:(id)sender {
    [[TwitterClient instance] favoriteTweet:self.currentTweet withSuccess:^(AFHTTPRequestOperation *operation, id response) {
        self.currentTweet.isFavorited=!self.currentTweet.isFavorited;
        [self updateIcons];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to favorite with error : %@",error);
    }];
}

- (void) updateIcons {
    if (self.currentTweet.isFavorited) {
        [self.favoriteButton setImage:[UIImage imageNamed:@"favorite_on"] forState:UIControlStateNormal];
    }
    else {
        [self.favoriteButton setImage:[UIImage imageNamed:@"favorite"] forState:UIControlStateNormal];
    }
    
    if( self.currentTweet.isRetweeted) {
        [self.reTweetButton setImage:[UIImage imageNamed:@"retweet_on"] forState:UIControlStateNormal];
    }
    else {
        [self.reTweetButton setImage:[UIImage imageNamed:@"retweet"] forState:UIControlStateNormal];
    }
}

# pragma mark TweetComposeViewControllerDelegate

- (void)onCancel {
    NSLog(@" Tweet post cancelled");
}

- (void)onTweet:(Tweet *)tweet {
    
    [[TwitterClient instance] postTweet:tweet.tweetText inReplyTo:nil WithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"reply to tweet posted with text: %@",tweet.tweetText);
        self.replyPostedLabel.text=@"Reply posted";
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Replying to tweet failed with error: %@",error);
        
    }];
}


@end

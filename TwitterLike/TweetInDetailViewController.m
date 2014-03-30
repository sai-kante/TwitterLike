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

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@implementation UIImageView (setRoundedCorners)
-(void) setRoundedCorners {
    self.layer.cornerRadius = 9.0;
    self.layer.masksToBounds = YES;
}
@end

@interface TweetInDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *reTweets;
@property (weak, nonatomic) IBOutlet UILabel *favorites;
@property (strong, nonatomic) IBOutlet UIImageView *replyicon;
@property (weak, nonatomic) IBOutlet UIImageView *reTweetIcon;
@property (weak, nonatomic) IBOutlet UIImageView *favoriteIcon;

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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reply" style:UIBarButtonItemStylePlain target:self action:@selector(onReplyButton:)];
        
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
    
    self.reTweetIcon.image=[UIImage imageNamed:@"retweet.png"];
    self.replyicon.image=[UIImage imageNamed:@"reply.png"];
    self.favoriteIcon.image=[UIImage imageNamed:@"favorite.png"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onReplyButton:(id)sender {
    
}

@end

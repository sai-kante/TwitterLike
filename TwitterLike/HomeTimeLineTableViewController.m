//
//  HomeTimeLineTableViewController.m
//  TwitterLike
//
//  Created by Sai Kante on 3/29/14.
//  Copyright (c) 2014 saiPersonal. All rights reserved.
//

#import "HomeTimeLineTableViewController.h"
#import "HomeTimeLineTableViewCell.h"
#import "Tweet.h"
#import "TwitterClient.h"
#import "AFNetworking.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MBProgressHUD.h"
#import "TweetInDetailViewController.h"
#import "User.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

static NSString *CellIdentifier = @"HomeTimeLineTableViewCell";
static int CustomTableViewCellHeight=125;
static int TweetTextLabelFontSize=13;
static int TweetTextLabelWidth=245;

@interface HomeTimeLineTableViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HomeTimeLineTableViewController{
    UIRefreshControl *refresh;
    MBProgressHUD *progressHUD;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tweets = [[NSMutableArray alloc] init];
        //get user info
        [[TwitterClient instance] requestUserInfoWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *userInfo=(NSDictionary*)responseObject;
            [[User instance] setCurrentUserInfo:userInfo];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed to retrieve user info with error : %@",error);
        }];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.title=@"Recent Tweets";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(onLogoutButton:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Compose" style:UIBarButtonItemStylePlain target:self action:@selector(onComposeButton:)];

    
    progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [progressHUD hide:YES];
    
    refresh = [[UIRefreshControl alloc] init];
    refresh.tintColor = [UIColor grayColor];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl = refresh;
    
    UINib *customCellNib= [UINib nibWithNibName:CellIdentifier bundle:nil];
    [self.tableView registerNib:customCellNib forCellReuseIdentifier:CellIdentifier];
    self.tableView.delegate = self;
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.tweets.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tweet *tweet= [[Tweet alloc] init];
    tweet = self.tweets[indexPath.row];
    CGSize size=[self getCGSizeOfTextLabelWithText:tweet.tweetText andWidth:TweetTextLabelWidth];
    CGSize size2=[self getCGSizeOfTextLabelWithText:@"" andWidth:TweetTextLabelWidth];
    return size.height-(3*size2.height)+CustomTableViewCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HomeTimeLineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                                forIndexPath:indexPath];
    Tweet *tweet= [[Tweet alloc] init];
    tweet = self.tweets[indexPath.row];
    [cell.tweetText setLineBreakMode:NSLineBreakByWordWrapping];
    [cell.tweetText setNumberOfLines:0];
    cell.tweetText.text = tweet.tweetText;
    cell.tweetText.preferredMaxLayoutWidth = CGRectGetWidth(tableView.bounds);

    [cell.profileImage setImageWithURL:[NSURL URLWithString:tweet.profileImageUrl] placeholderImage:[UIImage imageNamed:@"noImage.png"]];
    [cell.profileImage setRoundedCorners];
    
    cell.screenName.text = [NSString stringWithFormat:@"@%@",tweet.screenName];
    cell.userName.text= tweet.userName;
    cell.timeSince.text= tweet.timeSince;
    cell.numberOfReplies.text = tweet.numberOfReplies;
    cell.numberOfRetweets.text = tweet.numberOfRetweets;
    cell.numberOfFavorites.text = tweet.numberOfFavorites;
    
    //add a nice separator
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, 280, 1)];
    separatorLineView.backgroundColor = [UIColor grayColor];// you can also put image here
    [cell.contentView addSubview:separatorLineView];
    
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetInDetailViewController *detailedView=[[TweetInDetailViewController alloc] init];
    detailedView.currentTweet=self.tweets[indexPath.row];
    if(detailedView.currentTweet!=NULL) {
        [self.navigationController pushViewController:detailedView animated:YES];
    }
}

#pragma mark - Helper methods for this class

- (CGSize) getCGSizeOfTextLabelWithText:(NSString*)text andWidth:(int)width {
    UIFont *font = [UIFont boldSystemFontOfSize: TweetTextLabelFontSize];
    NSDictionary *attributes = @{NSFontAttributeName: font};
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:attributes
                                          context:nil];
    return rect.size;
    
}

-(void)refreshView:(UIRefreshControl *)refreshC {
    
    refreshC.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
    [progressHUD show:YES];
    TwitterClient *client=[TwitterClient instance];
    [client requestHomeTimelineWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *tweets=(NSArray*)responseObject;
        NSMutableArray *tweetsArray = [[NSMutableArray alloc] init];
        for(NSDictionary *tweetSrc in tweets) {
            Tweet *tweet= [[Tweet alloc] init];
            [tweet initTweetWithDictionary:tweetSrc];
            [tweetsArray addObject:tweet];
        }
        self.tweets=tweetsArray;
        [progressHUD hide:YES];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [progressHUD hide:YES];

        NSLog(@"failed to retrieve timeline with error : %@",error);
    }];
    [refreshC endRefreshing];
    
}

-(IBAction) onLogoutButton:(id)sender {
    TwitterClient *client=[TwitterClient instance];
    [client deauthorize];
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction) onComposeButton:(id)sender {
    TweetComposeViewController *composeView= [[TweetComposeViewController alloc] init];
    composeView.delegate=self;
    Tweet *currentTweet= [[Tweet alloc] init];
    User *user= [User instance];
    currentTweet.screenName = user.screenName;
    currentTweet.profileImageUrl = user.profileImageUrl;
    currentTweet.userName =user.userName;
    composeView.currentTweet=currentTweet;
    [self presentViewController:composeView animated:YES completion:^{}];
}

# pragma mark TweetComposeViewControllerDelegate

- (void)onCancel {
    NSLog(@" Tweet post cancelled");
}

- (void)onTweet:(Tweet *)tweet {
    [self.tweets removeLastObject];
    [self.tweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
    [[TwitterClient instance] postTweet:tweet.tweetText inReplyTo:nil WithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Tweet posted with text: %@",tweet.tweetText);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Tweet posting failed with error: %@",error);
        
    }];
}

@end

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


#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

static NSString *CellIdentifier = @"HomeTimeLineTableViewCell";
static int CustomTableViewCellHeight=125;
static int TweetTextLabelFontSize=13;
static int TweetTextLabelWidth=245;

@implementation UIImageView (setRoundedCorners)
-(void) setRoundedCorners {
    self.layer.cornerRadius = 9.0;
    self.layer.masksToBounds = YES;
}
@end

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
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self navigationController].navigationBarHidden=NO;
    [self navigationController].title=@"Recent Tweets";
    
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
    return 10;
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


@end

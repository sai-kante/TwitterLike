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
#import "AFNetworking.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

static NSString *CellIdentifier = @"HomeTimeLineTableViewCell";
static int CustomTableViewCellHeight=125;
static int TweetTextLabelFontSize=13;
static int TweetTextLabelWidth=245;

@interface HomeTimeLineTableViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HomeTimeLineTableViewController

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
    
    UINib *customCellNib= [UINib nibWithNibName:CellIdentifier bundle:nil];
    [self.tableView registerNib:customCellNib forCellReuseIdentifier:CellIdentifier];
    
    [self navigationController].navigationBarHidden=NO;
    [self navigationController].title=@"Recent Tweets";
    
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

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

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

@end

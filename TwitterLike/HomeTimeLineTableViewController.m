//
//  HomeTimeLineTableViewController.m
//  TwitterLike
//
//  Created by Sai Kante on 3/29/14.
//  Copyright (c) 2014 saiPersonal. All rights reserved.
//

#import "HomeTimeLineTableViewController.h"
#import "HomeTimeLineTableViewCell.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

static NSString *CellIdentifier = @"HomeTimeLineTableViewCell";
static int CustomTableViewCellHeight=136;
static int TweetTextLabelFontSize=13;
static int TweetTextLabelWidth=245;

@interface HomeTimeLineTableViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HomeTimeLineTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    UINib *customCellNib= [UINib nibWithNibName:CellIdentifier bundle:nil];
    [self.tableView registerNib:customCellNib forCellReuseIdentifier:CellIdentifier];
    
    
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
    HomeTimeLineTableViewCell *cell = [[HomeTimeLineTableViewCell alloc] init];
//    NSDictionary *business=self.businessesList[indexPath.row];
    NSString* tweetText=@" this is a sample tweet. this is a sample tweet. this is a sample tweet. this is a sample tweet. this is a sample tweet. this is a sample tweet. this is a sample tweet. this is a sample tweet. ";
    [cell.tweetText setLineBreakMode:NSLineBreakByWordWrapping];
    [cell.tweetText setNumberOfLines:0];
    cell.tweetText.text = tweetText;
    CGSize size=[self getCGSizeOfTextLabelWithText:tweetText andWidth:TweetTextLabelWidth];
    //cell.Name.frame = CGRectMake(0, 0, size.width, size.height);
    
    NSLog(@"----%@ height: %f",tweetText,size.height);
    [cell.tweetText sizeToFit];
    
    return size.height+CustomTableViewCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HomeTimeLineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                                forIndexPath:indexPath];
    //NSDictionary *business=self.businessesList[indexPath.row];
    NSString* tweetText=@" this is a sample tweet. this is a sample tweet. this is a sample tweet. this is a sample tweet. this is a sample tweet. this is a sample tweet. this is a sample tweet. this is a sample tweet. ";
    [cell.tweetText setLineBreakMode:NSLineBreakByWordWrapping];
    [cell.tweetText setNumberOfLines:0];
    cell.tweetText.text = tweetText;
    //[cell.Image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[business objectForKey:@"image_url"]]] placeholderImage:[UIImage imageNamed:@"noImage.png"]];
    
    CGSize size=[self getCGSizeOfTextLabelWithText:tweetText andWidth:TweetTextLabelWidth];
    
    NSLog(@"--%@ height: %f",tweetText,size.height);
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    cell.tweetText.preferredMaxLayoutWidth = CGRectGetWidth(tableView.bounds);
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

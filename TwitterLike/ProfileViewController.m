//
//  ProfileViewController.m
//  TwitterLike
//
//  Created by Sai Kante on 4/7/14.
//  Copyright (c) 2014 saiPersonal. All rights reserved.
//

#import "ProfileViewController.h"
#import "AFNetworking.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *tweetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageConrtol;
- (IBAction)onBackButton:(id)sender;

@property (nonatomic, strong) UIImageView *imageView1;
@property (nonatomic, strong) UIImageView *imageView2;


@end

@implementation ProfileViewController

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
    // Do any additional setup after loading the view from its nib.
    self.scrollView.delegate=self;
    
    self.tweetsLabel.text = [self.user numTweets];
    self.followersLabel.text = [self.user numFollowers];
    self.followingLabel.text = [self.user numFollowing];
    
    
    [self.imageView1 setImageWithURL:[NSURL URLWithString:[self.user backgroundImageUrl]] placeholderImage:[UIImage imageNamed:@"noImage.png"]];
    
    [self.imageView2 setImageWithURL:[NSURL URLWithString:[self.user profileImageUrl]] placeholderImage:[UIImage imageNamed:@"noImage.png"]];
    
    
    for (int i = 0; i < 2; i++) {
        //We'll create an imageView object in every 'page' of our scrollView.
        CGRect frame;
        frame.origin.x = self.scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        
        if(i==0)
            //imageView.image = [UIImage imageNamed:@"noImage.png"];
            [imageView setImageWithURL:[NSURL URLWithString:[self.user backgroundImageUrl]] placeholderImage:[UIImage imageNamed:@"noImage.png"]];
        else
             [imageView setImageWithURL:[NSURL URLWithString:[self.user profileImageUrl]] placeholderImage:[UIImage imageNamed:@"noImage.png"]];
        [self.scrollView addSubview:imageView];
    }
    
    //Set the content size of our scrollview according to the total width of our imageView objects.
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width *2, self.scrollView.frame.size.height);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageConrtol.currentPage = page;
}


- (IBAction)onBackButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}
@end

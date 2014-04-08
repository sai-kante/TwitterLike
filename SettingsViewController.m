//
//  SettingsViewController.m
//  TwitterLike
//
//  Created by Sai Kante on 4/6/14.
//  Copyright (c) 2014 saiPersonal. All rights reserved.
//

#import "SettingsViewController.h"
#import "AFNetworking.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "User.h"
#import "Tweet.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
- (IBAction)onHomeButton:(id)sender;
- (IBAction)onMentionsButton:(id)sender;
- (IBAction)onProfileButton:(id)sender;

@end

@implementation SettingsViewController

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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onHomeButton:(id)sender {
    [self.delegate homeButtonClicked];
}

- (IBAction)onMentionsButton:(id)sender {
    [self.delegate mentionsButtonClicked];
}

- (IBAction)onProfileButton:(id)sender {
    [self.delegate profileButtonClicked];
}

- (void)updateContent {
    User *user = [User instance];
    NSString *imageUrl= [[user profileImageUrl] stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
    [self.profileImage setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"noImage.png"]];
    [self.profileImage setRoundedCorners];
    self.screenName.text=[NSString stringWithFormat:@"@%@",user.screenName];
    self.name.text=user.userName;
}

@end

//
//  TweetComposeViewController.m
//  TwitterLike
//
//  Created by Sai Kante on 3/30/14.
//  Copyright (c) 2014 saiPersonal. All rights reserved.
//

#import "TweetComposeViewController.h"
#import "AFNetworking.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface TweetComposeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *numberOfCharsLeft;
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
- (IBAction)onCancelButton:(id)sender;
- (IBAction)onTweetButton:(id)sender;

@end

@implementation TweetComposeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.currentTweet = [[Tweet alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tweetTextView.delegate=self;
    
    [self.profileImage setImageWithURL:[NSURL URLWithString:self.currentTweet.profileImageUrl] placeholderImage:[UIImage imageNamed:@"noImage.png"]];
    [self.profileImage setRoundedCorners];
    self.screenName.text=[NSString stringWithFormat:@"@%@",self.currentTweet.screenName];
    self.userName.text=self.currentTweet.userName;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onCancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate onCancel];
    }];
}

- (IBAction)onTweetButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        self.currentTweet.tweetText=self.tweetTextView.text;
        [self.delegate onTweet:self.currentTweet];
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

#pragma mark UITextViewDelegate

- (void)textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"textViewDidEndEditing:");
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSCharacterSet *doneButtonCharacterSet = [NSCharacterSet newlineCharacterSet];
    NSRange replacementTextRange = [text rangeOfCharacterFromSet:doneButtonCharacterSet];
    NSUInteger location = replacementTextRange.location;
    self.numberOfCharsLeft.text=[NSString stringWithFormat:@"%d",140-(textView.text.length + text.length)];
    if (textView.text.length + text.length > 140){
        if (location != NSNotFound){
            [textView resignFirstResponder];
        }
        return NO;
    }
    else if (location != NSNotFound){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end

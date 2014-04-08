//
//  HomeViewController.m
//  TwitterLike
//
//  Created by Sai Kante on 4/6/14.
//  Copyright (c) 2014 saiPersonal. All rights reserved.
//

#import "HomeViewController.h"
#import "TwitterClient.h"
#import "ProfileViewController.h"

@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (strong, nonatomic) UINavigationController *homeTimeLineNC;
@property (strong, nonatomic) UINavigationController *settingsNC;
@property (strong, nonatomic) SettingsViewController *settingsVC;
@property (strong, nonatomic) HomeTimeLineTableViewController *homeTimeLineVC;
@property (assign, nonatomic) BOOL isSettingsViewVisible;

@end

@implementation HomeViewController

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
    
    //hide the navigation bar
    self.navigationController.navigationBar.hidden=YES;
    
    // Do any additional setup after loading the view from its nib.
    self.homeTimeLineVC = [[HomeTimeLineTableViewController alloc] init];
    self.homeTimeLineVC.tweets= self.tweets;
    self.homeTimeLineVC.timeLineType=HOME_TIMELINE;
    self.homeTimeLineVC.delegate=self;
    
    self.homeTimeLineNC = [[UINavigationController alloc]
                                            initWithRootViewController:self.homeTimeLineVC];
    self.homeTimeLineNC.navigationBar.barTintColor = [UIColor colorWithRed:113/255.0f green:228/255.0f blue:246/255.0f alpha:1.0f];
    
    self.settingsVC = [[SettingsViewController alloc] init];
    
    self.settingsNC = [[UINavigationController alloc]
                           initWithRootViewController:self.settingsVC];
    self.settingsNC.navigationBar.barTintColor = [UIColor colorWithRed:113/255.0f green:228/255.0f blue:246/255.0f alpha:1.0f];
    
    self.settingsVC.delegate=self;
    
    UIView *view1=self.homeTimeLineNC.view;
    UIView *view2=self.settingsNC.view;
    view1.frame=self.firstView.frame;
    view2.frame=self.firstView.frame;
    
    [self.firstView addSubview:view1];
    [self.firstView addSubview:view2];
    
    [self.settingsVC updateContent];
    
    [self.firstView bringSubviewToFront:view1];
    self.isSettingsViewVisible = NO;
    
    //add pan recongnizer to firstView
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc ] initWithTarget:self action:@selector(onPan:)];
    
    [view1 addGestureRecognizer:panGR];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) onPan:(UIPanGestureRecognizer *)panGC {
    CGPoint velocity = [panGC velocityInView:self.firstView];
    UIView *view= [panGC view];
    
    if(panGC.state == UIGestureRecognizerStateBegan) {
        [self.settingsVC updateContent];
    }
    else if(panGC.state == UIGestureRecognizerStateChanged) {
        //view.center = CGPointMake(point.x,view.center.y);
        if (velocity.x > 0) {
            CGRect viewFrame = view.frame;
            if (viewFrame.origin.x <= 280) {
                viewFrame.origin.x += 10;
                view.frame = viewFrame;
            }
        }
    }
    else if(panGC.state == UIGestureRecognizerStateEnded) {
        
        [UIView animateWithDuration:0.5  animations:^{
            // slide back the timeline
            if (velocity.x <= 0) {
                CGRect viewFrame = view.frame;
                viewFrame.origin.x = 0;
                view.frame = viewFrame;
            }
            // show the settings view
            else {
                CGRect viewFrame = view.frame;
                viewFrame.origin.x = 280;
                view.frame = viewFrame;
                
            }
        }];
    }
    
}

- (void)panBackTimeLineView {
    [UIView animateWithDuration:0.5  animations:^{
        // slide back the timeline
        CGRect viewFrame = self.homeTimeLineNC.view.frame;
        viewFrame.origin.x = 0;
        self.homeTimeLineNC.view.frame = viewFrame;
    }];
}

- (void) homeButtonClicked {
    self.homeTimeLineVC.timeLineType=HOME_TIMELINE;
    [self.homeTimeLineVC reloadTimeLine];
    [self panBackTimeLineView];
}

- (void) mentionsButtonClicked {
    self.homeTimeLineVC.timeLineType=MENTIONS_TIMELINE;
    [self.homeTimeLineVC reloadTimeLine];
    [self panBackTimeLineView];
}

- (void) logoutButtonClicked {
    TwitterClient *client=[TwitterClient instance];
    [client deauthorize];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) profileButtonClicked {
    ProfileViewController *profileView = [[ProfileViewController alloc] init];
    profileView.user = [User instance];
    [self.navigationController presentViewController:profileView animated:YES completion:^{}];
}

@end

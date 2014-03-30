//
//  HomeTimeLineTableViewCell.h
//  TwitterLike
//
//  Created by Sai Kante on 3/29/14.
//  Copyright (c) 2014 saiPersonal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTimeLineTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lastRetweetedText;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *timeSince;
@property (weak, nonatomic) IBOutlet UILabel *numberOfReplies;
@property (weak, nonatomic) IBOutlet UILabel *numberOfRetweets;
@property (weak, nonatomic) IBOutlet UILabel *numberOfFavorites;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;

@end

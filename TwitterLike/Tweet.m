//
//  Tweet.m
//  TwitterLike
//
//  Created by Sai Kante on 3/29/14.
//  Copyright (c) 2014 saiPersonal. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (void)initTweetWithDictionary:(NSDictionary*)tweetDict {
//    @property (weak, nonatomic) NSString *profileImageUrl;
//    @property (weak, nonatomic) NSString *userName;
//    @property (weak, nonatomic) NSString *screenName;
//    @property (weak, nonatomic) NSString *timeSince;
//    @property (assign, nonatomic) NSInteger numberOfReplies;
//    @property (assign, nonatomic) NSInteger numberOfRetweets;
//    @property (assign, nonatomic) NSInteger numberOfFavorites;
//    @property (weak, nonatomic) NSString *tweetText;
    self.tweetText=[NSString stringWithFormat:@"%@",[tweetDict objectForKey:@"text"]];
    self.numberOfRetweets= [NSString stringWithFormat:@"%@",[tweetDict objectForKey:@"retweet_count"]];
    self.numberOfFavorites= [NSString stringWithFormat:@"%@",[tweetDict objectForKey:@"favorite_count"]];
    self.numberOfReplies= [NSString stringWithFormat:@"%@",[tweetDict objectForKey:@"retweet_count"]];
    NSDictionary *user = [tweetDict objectForKey:@"user"];
    self.userName = [NSString stringWithFormat:@"%@",[user objectForKey:@"name"]];
    self.screenName = [NSString stringWithFormat:@"%@",[user objectForKey:@"screen_name"]];
    self.profileImageUrl = [NSString stringWithFormat:@"%@",[user objectForKey:@"profile_image_url"]];
    
    self.timeSince = [self dateDiff:[NSString stringWithFormat:@"%@",[tweetDict objectForKey:@"created_at"]]];
}


-(NSString *)dateDiff:(NSString *)origDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
    NSDate *convertedDate = [dateFormatter dateFromString:origDate];
    NSDate *todayDate = [NSDate date];
    double ti = [convertedDate timeIntervalSinceDate:todayDate];
    ti = ti * -1;
    if(ti < 1) {
    	return @"never";
    } else 	if (ti < 60) {
    	return @"less than a minute ago";
    } else if (ti < 3600) {
    	int diff = round(ti / 60);
    	return [NSString stringWithFormat:@"%dm ago", diff];
    } else if (ti < 86400) {
    	int diff = round(ti / 60 / 60);
    	return[NSString stringWithFormat:@"%dh ago", diff];
    } else if (ti < 2629743) {
    	int diff = round(ti / 60 / 60 / 24);
    	return[NSString stringWithFormat:@"%dd ago", diff];
    } else {
    	return @"never";
    }
}


@end

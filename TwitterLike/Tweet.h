//
//  Tweet.h
//  TwitterLike
//
//  Created by Sai Kante on 3/29/14.
//  Copyright (c) 2014 saiPersonal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : NSObject

@property (retain, nonatomic) NSString *profileImageUrl;
@property (retain, nonatomic) NSString *userName;
@property (retain, nonatomic) NSString *screenName;
@property (retain, nonatomic) NSString *timeSince;
@property (retain, nonatomic) NSString *numberOfReplies;
@property (retain, nonatomic) NSString *numberOfRetweets;
@property (retain, nonatomic) NSString *numberOfFavorites;
@property (retain, nonatomic) NSString *tweetText;
@property (nonatomic, assign) BOOL isFavorited;
@property (nonatomic, assign) BOOL isRetweeted;
@property (nonatomic, retain) NSString *tweetId;
@property (nonatomic,retain) NSDictionary *tweetDict;

- (void)initTweetWithDictionary:(NSDictionary*)tweetDict;

@end

@interface UIImageView (setRoundedCorners)

@end

@implementation UIImageView (setRoundedCorners)
-(void) setRoundedCorners {
    self.layer.cornerRadius = 9.0;
    self.layer.masksToBounds = YES;
}
@end


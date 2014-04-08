//
//  User.m
//  TwitterLike
//
//  Created by Sai Kante on 3/30/14.
//  Copyright (c) 2014 saiPersonal. All rights reserved.
//

#import "User.h"

@implementation User

+ (User*) instance {
    static User* instance=NULL;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^ {
        instance = [[User alloc] init];
    });
    
    return instance;
}

+ (User *)fetchUserFromInfoDict : (NSDictionary*)userInfo {
    User *user= [[User alloc] init];
    user.userInfo = userInfo;
    user.userName = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"name"]];
    user.screenName = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"screen_name"]];
    user.profileImageUrl = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"profile_image_url"]];
    user.backgroundImageUrl = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"profile_background_image_url"]];
    user.numFollowers = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"followers_count"]];
    user.numFollowing = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"friends_count"]];
    user.numTweets = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"statuses_count"]];
    return user;
}


- (void)setCurrentUserInfo : (NSDictionary*)userInfo {
    [User instance].userInfo = userInfo;
    [User instance].userName = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"name"]];
    [User instance].screenName = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"screen_name"]];
    [User instance].profileImageUrl = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"profile_image_url"]];
    [User instance].backgroundImageUrl = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"profile_background_image_url"]];
    [User instance].numFollowers = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"followers_count"]];
    [User instance].numFollowing = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"friends_count"]];
    [User instance].numTweets = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"statuses_count"]];
}

- (void)saveCurrentUserToNSUserDefaults {
    [[NSUserDefaults standardUserDefaults] setObject:[User instance] forKey:@"TwitterLike_User"];
}

- (void)fetchCurrentUserFromNSUserDefaults {
    User* user= [[NSUserDefaults standardUserDefaults] objectForKey:@"TwitterLike_User"];
    [[User instance] setCurrentUserInfo:user.userInfo];
}


@end

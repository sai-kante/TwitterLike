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

- (void)setCurrentUserInfo : (NSDictionary*)userInfo {
    [User instance].userInfo = userInfo;
    [User instance].userName = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"name"]];
    [User instance].screenName = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"screen_name"]];
    [User instance].profileImageUrl = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"profile_image_url"]];
    [User instance].backgroundImageUrl = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"profile_background_image_url"]];
}

- (void)saveCurrentUserToNSUserDefaults {
    [[NSUserDefaults standardUserDefaults] setObject:[User instance] forKey:@"TwitterLike_User"];
}

- (void)fetchCurrentUserFromNSUserDefaults {
    User* user= [[NSUserDefaults standardUserDefaults] objectForKey:@"TwitterLike_User"];
    [[User instance] setCurrentUserInfo:user.userInfo];
}
@end

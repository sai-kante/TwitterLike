//
//  User.m
//  TwitterLike
//
//  Created by Sai Kante on 3/29/14.
//  Copyright (c) 2014 saiPersonal. All rights reserved.
//

#import "User.h"
#import "TwitterClient.h"

@implementation User

static User *currentUser=nil;

+ (User*) currentUser {
    
    //retrieve from user defaults
    if(currentUser==nil) {
        NSObject *user= [[NSUserDefaults standardUserDefaults] objectForKey:@"TwitterLike_current_user_access_token"];
        if(user) {
            currentUser=(User*) user;
        }
    }
    
    return currentUser;
}

+ (void) setCurrentUserAs:(User*) user {
    //save to user defaults
    [[NSUserDefaults standardUserDefaults] setObject:user forKey:@"TwitterLike_current_user_access_token"];
}

@end

//
//  User.h
//  TwitterLike
//
//  Created by Sai Kante on 3/30/14.
//  Copyright (c) 2014 saiPersonal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (retain, nonatomic) NSString *profileImageUrl;
@property (retain, nonatomic) NSString *backgroundImageUrl;
@property (retain, nonatomic) NSString *userName;
@property (retain, nonatomic) NSString *screenName;
@property (retain, nonatomic) NSString *numFollowers;
@property (retain, nonatomic) NSString *numFollowing;
@property (retain, nonatomic) NSString *numTweets;
@property (retain, nonatomic) NSDictionary *userInfo;

+ (User*) instance;
+ (User *)fetchUserFromInfoDict : (NSDictionary*)userInfo;
- (void)setCurrentUserInfo : (NSDictionary*)userInfo;
- (void)saveCurrentUserToNSUserDefaults;
- (void)fetchCurrentUserFromNSUserDefaults;

@end

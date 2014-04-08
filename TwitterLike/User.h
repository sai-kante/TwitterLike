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
@property (retain, nonatomic) NSDictionary *userInfo;

+ (User*) instance;
- (void)setCurrentUserInfo : (NSDictionary*)userInfo;
- (void)saveCurrentUserToNSUserDefaults;
- (void)fetchCurrentUserFromNSUserDefaults;

@end

//
//  User.h
//  TwitterLike
//
//  Created by Sai Kante on 3/29/14.
//  Copyright (c) 2014 saiPersonal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

+ (User*) currentUser;

+ (void) setCurrentUserAs:(User*) user;

@end

//
//  TwitterClient.h
//  TwitterLike
//
//  Created by Sai Kante on 3/29/14.
//  Copyright (c) 2014 saiPersonal. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient*) instance;

- (void) login;

- (AFHTTPRequestOperation*) requestHomeTimelineWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end

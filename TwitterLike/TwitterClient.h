//
//  TwitterClient.h
//  TwitterLike
//
//  Created by Sai Kante on 3/29/14.
//  Copyright (c) 2014 saiPersonal. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "Tweet.h"

typedef enum
{
    HOME_TIMELINE,
    MENTIONS_TIMELINE
} TimeLineType;

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient*) instance;

- (void) login;

- (AFHTTPRequestOperation*) requestTimeline:(TimeLineType)type WithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


- (AFHTTPRequestOperation*) requestUserInfoWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure ;

- (AFHTTPRequestOperation*) requestUserInfoWithScreenName:(NSString*)screenName withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure ;


- (AFHTTPRequestOperation*) postTweet:(NSString*)tweetText inReplyTo:(NSString *)inReplyToTweetId WithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


- (void)favoriteTweet:(Tweet *)tweet withSuccess:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)retweetTweet:(Tweet *)tweet withSuccess:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end

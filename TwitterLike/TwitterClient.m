//
//  TwitterClient.m
//  TwitterLike
//
//  Created by Sai Kante on 3/29/14.
//  Copyright (c) 2014 saiPersonal. All rights reserved.
//

#import "TwitterClient.h"

@implementation TwitterClient

+ (TwitterClient*) instance {
    static TwitterClient* instance=NULL;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^ {
       instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.twitter.com"] consumerKey:@"99iZzJStEZ2eSa2ed62Dg" consumerSecret:@"Yy072Mi3ASXb7jIbgMJIoXpHEPf9e56OpGMDelEyQ"];
    });
    
    return instance;    
}

-(void) login {
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"POST" callbackURL:[NSURL URLWithString:@"cptwitter://oauth" ] scope:nil success:^(BDBOAuthToken *requestToken) {
        NSLog(@"Got the request token");
        [self.requestSerializer removeAccessToken];
        //send the user to twitter page to login
        NSString *authURL = [NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURL]];
        
    } failure:^(NSError *error) {
        NSLog(@"Failure : %@",error);
    }];
}

- (AFHTTPRequestOperation*) requestHomeTimelineWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSDictionary *parameters = @{@"count": @20};
    return [self GET:@"1.1/statuses/home_timeline.json" parameters:parameters success:success failure:failure];
}

- (AFHTTPRequestOperation*) requestUserInfoWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    return [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:success failure:failure];
}

- (AFHTTPRequestOperation*) postTweet:(NSString*)tweetText inReplyTo:(NSString *)inReplyToTweetId WithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{@"status": tweetText}];
    if (inReplyToTweetId != nil) {
        [parameters setObject:inReplyToTweetId forKey:@"in_reply_to_status_id"];
    }
    return [self POST:@"1.1/statuses/update.json" parameters:parameters constructingBodyWithBlock:nil success:success failure:failure];
}


- (void)favoriteTweet:(Tweet *)tweet withSuccess:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary *parameters = @{@"id": [tweet.tweetDict objectForKey:@"id"]};
    
    if (tweet.isFavorited) {
        [self POST:@"1.1/favorites/destroy.json" parameters:parameters success:success failure:failure];
    }
    else {
        [self POST:@"1.1/favorites/create.json" parameters:parameters success:success failure:failure];
    }
}

- (void)retweetTweet:(Tweet *)tweet withSuccess:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary *parameters = @{@"id": [tweet.tweetDict objectForKey:@"id"]};
    
    if (tweet.isRetweeted) {
        NSString *unRetweetPath = [NSString stringWithFormat:@"1.1/statuses/destroy/%@.json", [tweet.tweetDict objectForKey:@"id"]];
        [self POST:unRetweetPath parameters:parameters success:success failure:failure];
    }
    else {
        NSString *retweetPath = [NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", [tweet.tweetDict objectForKey:@"id"]];
        [self POST:retweetPath parameters:parameters success:success failure:failure];
    }
    
}

@end

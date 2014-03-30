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

@end

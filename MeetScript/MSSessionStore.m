//
//  MSSessionStore.m
//  MeetScript
//
//  Created by Shane Rogers on 2/24/15.
//  Copyright (c) 2015 SDR. All rights reserved.
//

#import "MSSessionStore.h"
#import "AFNetworking.h"

@implementation MSSessionStore

NSString const *kAPIUserLogin = @"http:localhost:3000/users";

+ (MSSessionStore *)sharedStore {
    static MSSessionStore *sessionStore = nil;

    static dispatch_once_t oncePredicate;

    dispatch_once(&oncePredicate, ^{
        sessionStore = [[MSSessionStore alloc] init];
    });
    return sessionStore;
}

// TODO: Branching sttrategy for social login
- (void)login:(NSDictionary *)parameters withCompletionBlock:(void (^)(MSSessionStore *session, NSError *err))block {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    NSString *requestURL = [self constructLoginRequest:parameters];

    [manager POST:requestURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Persist a login to the rails api
        // Send the social login data to the server
        // Use Devise for server login auth - generate token to make future API requests
        MSSessionStore *sessionStore = [MSSessionStore sharedStore];

        sessionStore.id = [responseObject objectForKey:@"id"];
        sessionStore.email = [responseObject objectForKey:@"email"];
        sessionStore.authenticationToken = [responseObject objectForKey:@"authentication_token"];
        sessionStore.profileImageUrl = [responseObject objectForKey:@"profile_image_url"];

        block(sessionStore, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
}

#pragma Session Helpers

- (NSString *)constructLoginRequest:(NSDictionary *)parameters {
    NSString *email = [parameters objectForKey:@"email"];
    NSString *password = [parameters objectForKey:@"password"];

    NSString *requestURL = [NSString stringWithFormat:kAPIUserLogin];
    requestURL = [requestURL stringByAppendingString:(@"?email=")];
    requestURL = [requestURL stringByAppendingString:email];
    requestURL = [requestURL stringByAppendingString:(@"&password=")];
    requestURL = [requestURL stringByAppendingString:password];
    return requestURL;
}

@end

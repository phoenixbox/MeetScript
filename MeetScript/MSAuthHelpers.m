//
//  MSAuthStore.m
//  MeetScript
//
//  Created by Shane Rogers on 2/24/15.
//  Copyright (c) 2015 SDR. All rights reserved.
//

#import "MSAuthHelpers.h"
#import "MSSessionStore.h"

@implementation MSAuthHelpers

+ (NSString *)authenticateRequest:(NSString *)requestURL {
    MSSessionStore *session = [MSSessionStore sharedStore];
    NSString *email = session.email;
    NSString *token = session.authenticationToken;

    requestURL = [requestURL stringByAppendingString:(@"?email=")];
    requestURL = [requestURL stringByAppendingString:email];
    requestURL = [requestURL stringByAppendingString:(@"&authentication_token=")];
    requestURL = [requestURL stringByAppendingString:token];

    return requestURL;
}


@end

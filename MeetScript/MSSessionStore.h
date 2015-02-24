//
//  MSSessionStore.h
//  MeetScript
//
//  Created by Shane Rogers on 2/24/15.
//  Copyright (c) 2015 SDR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSSessionStore : NSObject

@property (nonatomic) NSNumber *id;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *authenticationToken;
@property (strong, nonatomic) NSString *profileImageUrl;

+ (MSSessionStore *)sharedStore;
- (void)login:(NSDictionary *)loginParams withCompletionBlock:(void (^)(MSSessionStore *session, NSError *err))block;

@end

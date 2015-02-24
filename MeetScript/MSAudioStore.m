//
//  MSAudioStore.m
//  MeetScript
//
//  Created by Shane Rogers on 2/24/15.
//  Copyright (c) 2015 SDR. All rights reserved.
//

#import "MSAudioStore.h"
#import "AFNetworking.h"

@implementation MSAudioStore

+ (MSAudioStore *)sharedStore {
    static MSAudioStore *audioStore = nil;

    if (!audioStore) {
        audioStore = [[MSAudioStore alloc]init];
    };

    return audioStore;
}

- (void)saveAudioToServer:(NSData *)audioData withCompletion:(void (^)(NSError *err))block {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    // Restart create auth store
    NSString *requestURL = [MSAuthStore authenticateRequest:kAPIAudioCreate];

    MSSessionStore *session = [MSSessionStore sharedStore];

    NSDictionary *pieceParams = @{@"audio": audioData, @"user_id": [session.id stringValue]};

    [manager POST:requestURL parameters:pieceParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString* rawJSON = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        TAGPiece *piece = [[TAGPiece alloc] initWithString:rawJSON error:nil];
//
//        returnToUserProfile(piece, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


@end

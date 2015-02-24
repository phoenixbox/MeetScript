//
//  MSAudioStore.m
//  MeetScript
//
//  Created by Shane Rogers on 2/24/15.
//  Copyright (c) 2015 SDR. All rights reserved.
//

// Data layer
#import "MSAudioStore.h"
#import "MSSessionStore.h"
#import "MSAuthHelpers.h"

// Libs
#import "AFNetworking.h"

@implementation MSAudioStore

// Whats the best strategy for URL construction?
NSString const *kAPIAudioCreate = @"http:localhost:3000/users/:id/audio";

+ (MSAudioStore *)sharedStore {
    static MSAudioStore *audioStore = nil;

    if (!audioStore) {
        audioStore = [[MSAudioStore alloc]init];
    };

    return audioStore;
}

- (void)saveAudioToServer:(NSData *)audioData withCompletion:(void (^)(MSRecording *recording, NSError *err))returnToFinishedMeeting {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    NSString *requestURL = [MSAuthHelpers authenticateRequest:kAPIAudioCreate];

    MSSessionStore *session = [MSSessionStore sharedStore];

    // Clean up the request auth annotation
    NSDictionary *pieceParams = @{@"audio": audioData, @"user_id": [session.id stringValue]};

    [manager POST:requestURL parameters:pieceParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        TODO:Let the server persist the audio to s3?
        NSString* rawJSON = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        MSRecording *recording = [[MSRecording alloc] initWithString:rawJSON error:nil];

        returnToFinishedMeeting(recording, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


@end

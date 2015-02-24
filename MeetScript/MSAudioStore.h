//
//  MSAudioStore.h
//  MeetScript
//
//  Created by Shane Rogers on 2/24/15.
//  Copyright (c) 2015 SDR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSRecording.h"

@interface MSAudioStore : NSObject

+ (instancetype)sharedStore;

- (void)saveAudioToServer:(NSData *)audioData withCompletion:(void (^)(MSRecording *recording, NSError *err))returnToFinishedMeeting;

@end
//
//  MSStartMeetingViewController.m
//  MeetScript
//
//  Created by Shane Rogers on 2/24/15.
//  Copyright (c) 2015 SDR. All rights reserved.
//

#import "MSStartMeetingViewController.h"

@interface MSStartMeetingViewController ()

@property (nonatomic, assign) BOOL DEVELOPMENT_ENV;

@end

@implementation MSStartMeetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _DEVELOPMENT_ENV = true;
    // Do any additional setup after loading the view, typically from a nib.
    [_recordingControlsView setHidden:YES];

    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord
             withOptions:AVAudioSessionCategoryOptionDuckOthers
                   error:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)record:(id)sender {
    [_recordButton setTitle:@"Recording" forState:UIControlStateNormal];

    [_recordingControlsView setHidden:NO];

    NSError *error = nil;

    NSURL *audioRecordingPath = [self audioRecordingPath];
    NSDictionary *settings = [self audioRecordingSettings];

    // Note &error == ???
    _audioRecorder = [[AVAudioRecorder alloc] initWithURL:audioRecordingPath
                                                 settings:settings
                                                    error:&error];

    if(_audioRecorder != nil) {
        _audioRecorder.delegate = self;

        if ([_audioRecorder prepareToRecord] && [_audioRecorder record]) {
            NSLog(@"Started Recording");
        } else {
            NSLog(@"Recording Failed");
            self.audioRecorder = nil;
        }
    }

    NSLog(@"Implement audio recording");
}

- (NSURL *)audioRecordingPath {
    NSFileManager *fileManager = [[NSFileManager alloc] init];

    NSURL *documentsFolderUrl = [fileManager URLForDirectory:NSDocumentDirectory
                                                    inDomain:NSUserDomainMask
                                           appropriateForURL:nil
                                                      create:NO
                                                       error:nil];
    // TODO: Stream to remote location
    NSString *uuid = [[NSUUID UUID] UUIDString];
    NSString *resourceLocation = [NSString stringWithFormat:@"%@%@",uuid,@"&username.m4a"];

    NSLog(@"%@", resourceLocation);

    return [documentsFolderUrl URLByAppendingPathComponent:resourceLocation];
}

- (NSDictionary *)audioRecordingSettings {
    NSDictionary *settings = @{
                               AVFormatIDKey: @(kAudioFormatAppleLossless),
                               AVSampleRateKey: @(44100.0f),
                               AVNumberOfChannelsKey: @1,
                               AVEncoderAudioQualityKey: @(AVAudioQualityLow)
                               };

    return settings;
}

- (IBAction)pauseRecording:(AVAudioRecorder *)paramRecorder {
    [paramRecorder pause];
}

- (IBAction)finishRecording:(AVAudioRecorder *)paramRecorder {
        [paramRecorder stop];
}

#pragma AVFramework Protocol Functions

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    if (flag){
        NSLog(@"Successfully stopped the audio recording process.");
        /* Let's try to retrieve the data for the recorded file */
        NSError *playbackError = nil;
        NSError *readingError = nil;
        NSData  *fileData = [NSData dataWithContentsOfURL:[self audioRecordingPath]
                                                  options:NSDataReadingMapped
                                                    error:&readingError];

        // TODO: persist to external server which handles audio to text conversion
        // Load stock mp4 file here
        if (_DEVELOPMENT_ENV) {
            NSLog(@"Persist the audio to external server");
//            [[MSAudioStore sharedStore] persistAudioToServer];
        } else {
            NSLog(@"PROD: Stream the data to the server??");
        }
        self.audioPlayer = [[AVAudioPlayer alloc] initWithData:fileData
                                                         error:&playbackError];
        /* Could we instantiate the audio player? */
        if (self.audioPlayer != nil) {
            self.audioPlayer.delegate = self;
            /* Prepare to play and start playing */
            if ([self.audioPlayer prepareToPlay] && [self.audioPlayer play]){
                NSLog(@"Started playing the recorded audio.");
            } else {
                NSLog(@"Could not play the audio.");
            }
        } else {
            NSLog(@"Failed to create an audio player.");
        }
    } else {
        NSLog(@"Failed to stop the audio recording");
    }

    _audioRecorder = nil;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (flag){
        NSLog(@"Audio player stopped correctly.");
    } else {
        NSLog(@"Audio player did not stop correctly.");
    }
    if ([player isEqual:self.audioPlayer]) {
        self.audioPlayer = nil;
    } else {
        /* This is not our player */
    }
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    /* The audio session has been deactivated here */
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player
                       withOptions:(NSUInteger)flags {

    if (flags == AVAudioSessionInterruptionOptionShouldResume){
        [player play];
    }
}

@end
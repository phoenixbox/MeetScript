//
//  MSStartMeetingViewController.m
//  MeetScript
//
//  Created by Shane Rogers on 2/24/15.
//  Copyright (c) 2015 SDR. All rights reserved.
//

#import "MSStartMeetingViewController.h"
#import "MSAudioStore"

@interface MSStartMeetingViewController ()

@property (nonatomic, assign) BOOL DEVELOPMENT_ENV;
@property (nonatomic, strong) NSData *lastAudioData;

@end

NSString * const kPause = @"Pause";
NSString * const kStop = @"Stop";
NSString * const kResume = @"Resume";

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

- (IBAction)pauseRecording:(id)paramSender {
    [_audioRecorder pause];
}

- (IBAction)finishRecording:(id)paramSender {
    [_audioRecorder stop];
}

- (void)loadAndPlayFile {
    dispatch_queue_t dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    dispatch_async(dispatchQueue, ^(void) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString* docDir = [paths objectAtIndex:0];
        NSString* resourceLocation = [NSString stringWithFormat:@"%@%@",docDir,@"/the_national.m4a"];

        NSData *fileData = [NSData dataWithContentsOfFile:resourceLocation];
        _lastAudioData = fileData;

        void(^completionBlock)(NSError *err)=^(NSError *err){
            if(!err){
                NSLog(@"Successful save to server!");
            } else {
                NSLog(@"Error saving to server :(");
            }
        };

        [MSAudioStore saveAudioToServer:filedData withCompletion:completionBlock];
//        [self playAudioForData:fileData];
    });
}

- (void)playAudioForData:(NSData *)data {
    NSError *playbackError = nil;

    _audioPlayer = [[AVAudioPlayer alloc] initWithData:data
                                                 error:&playbackError];
    /* Could we instantiate the audio player? */
    if (self.audioPlayer != nil) {
        self.audioPlayer.delegate = self;
        /* Prepare to play and start playing */
        if ([self.audioPlayer prepareToPlay] && [self.audioPlayer play]) {
            NSLog(@"Started playing the recorded audio.");
        } else {
            NSLog(@"Could not play the audio.");
        }
    } else {
        NSLog(@"Failed to create an audio player.");
    }
}

- (void)saveAudioToServer {
    NSError *readingError = nil;

    NSData *fileData = [NSData dataWithContentsOfURL:[self audioRecordingPath]
                                              options:NSDataReadingMapped
                                                error:&readingError];
    _lastAudioData = fileData;

    NSLog(@"PROD: Stream the data to the server??");
    [self playAudioForData:fileData];
}

#pragma AVFramework Protocol Functions

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    if (flag){
        NSLog(@"Successfully stopped the audio recording process.");
        /* Let's try to retrieve the data for the recorded file */
        // TODO: persist to external server which handles audio to text conversion
        if (_DEVELOPMENT_ENV) {
            [self loadAndPlayFile];
        } else {
            [self saveAudioToServer];
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

- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder {
    NSLog(@"Recording has been interrupted");
}

- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder
                       withOptions:(NSUInteger)flags {
    NSLog(@"Interruption over");

    if (flags == AVAudioSessionInterruptionOptionShouldResume) {
        [recorder record];
    }
}

- (IBAction)togglePlayback:(UIButton *)buttonSender {
    NSString *buttonTitle = [buttonSender titleForState:UIControlStateNormal];

    if ([buttonTitle isEqualToString:kPause]) {
        [_audioPlayer pause];
        [buttonSender setTitle:kResume forState:UIControlStateNormal];
    } else if ([buttonTitle isEqualToString:kResume]) {
        [_audioPlayer play];
        [buttonSender setTitle:kPause forState:UIControlStateNormal];
    } else {
        NSLog(@"WARNING: Buttons state not recognized");
    }
}
@end
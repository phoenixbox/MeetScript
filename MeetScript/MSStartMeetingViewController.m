//
//  MSStartMeetingViewController.m
//  MeetScript
//
//  Created by Shane Rogers on 2/24/15.
//  Copyright (c) 2015 SDR. All rights reserved.
//

#import "MSStartMeetingViewController.h"

@interface MSStartMeetingViewController ()

@end

@implementation MSStartMeetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

    NSURL *audioRecordingURL = [self audioRecordingURL];
    NSDictionary *settings = [self audioRecordingSettings];

    // Note &error == ???
    _audioRecorder = [[AVAudioRecorder alloc] initWithURL:audioRecordingURL
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

- (NSURL *)audioRecordingURL {
    NSURL *audioRecordingURL = [NSURL new];

    return audioRecordingURL;
}

- (NSDictionary *)audioRecordingSettings {
    NSDictionary *settings = [NSDictionary new];

    return settings;
}

- (IBAction)pauseRecording:(id)sender {
}
- (IBAction)finishRecording:(id)sender {
}
@end

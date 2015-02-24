//
//  MSStartMeetingViewController.h
//  MeetScript
//
//  Created by Shane Rogers on 2/24/15.
//  Copyright (c) 2015 SDR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface MSStartMeetingViewController : UIViewController <AVAudioPlayerDelegate, AVAudioRecorderDelegate>

@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (nonatomic, strong) AVAudioRecorder *audioRecorder;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@property (weak, nonatomic) IBOutlet UIView *recordingControlsView;
- (IBAction)record:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *pauseRecordingButton;
- (IBAction)pauseRecording:(id)paramSender;

@property (weak, nonatomic) IBOutlet UIButton *finishRecordingButton;
- (IBAction)finishRecording:(id)paramSender;

@end

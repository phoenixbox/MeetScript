//
//  MSLoginViewController.h
//  MeetScript
//
//  Created by Shane Rogers on 2/23/15.
//  Copyright (c) 2015 SDR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSLoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)loginWithLinkedIn:(id)sender;

@end


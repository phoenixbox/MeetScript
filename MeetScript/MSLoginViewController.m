//
//  MSLoginViewController.m
//  MeetScript
//
//  Created by Shane Rogers on 2/23/15.
//  Copyright (c) 2015 SDR. All rights reserved.
//

#import "MSLoginViewController.h"
#import "AFHTTPRequestOperation.h"
#import "LIALinkedInHttpClient.h"
#import "LIALinkedInApplication.h"

// Constants
#import "AppConstants.h"

NSString *const kOAuthEndpoint = @"https://api.linkedin.com/v1/people/~?oauth2_access_token=%@&format=json";
NSString *const kAppRedirectURL = @"http://lvh.me:3000/";

@interface MSLoginViewController ()

@property (assign, nonatomic) BOOL DEVELOPMENT_ENV;

@end

@implementation MSLoginViewController {
    LIALinkedInHttpClient *_client;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _DEVELOPMENT_ENV = true;
    _client = [self client];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginWithLinkedIn:(id)sender {
    if(_DEVELOPMENT_ENV) {
        [self performSegueWithIdentifier:@"loggedIn" sender:nil];
    } else {
        [self.client getAuthorizationCode:^(NSString *code) {
            NSLog(@"**** Login Code: %@", code);
            [self.client getAccessToken:code
                                success:^(NSDictionary *accessTokenData) {
                                    NSString *accessToken = [accessTokenData objectForKey:@"access_token"];
                                    [self requestMeWithToken:accessToken];
                                } failure:^(NSError *error) {
                                    NSLog(@"Quering accessToken failed %@", error);
                                }
             ];
        }                      cancel:^{
            NSLog(@"Authorization was cancelled by user");
        }                     failure:^(NSError *error) {
            NSLog(@"Authorization failed %@", error);
        }];
    }

}

- (void)requestMeWithToken:(NSString *)accessToken {
    [self.client GET:[NSString stringWithFormat:kOAuthEndpoint, accessToken] parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *result) {
        NSLog(@"current user %@", result);
    }        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed to fetch current user %@", error);
    }];
}

 - (LIALinkedInHttpClient *)client {
     LIALinkedInApplication *application = [LIALinkedInApplication applicationWithRedirectURL:kAppRedirectURL
                                                                                    clientId:LINKEDIN_CLIENT_ID
                                                                                clientSecret:LINKEDIN_CLIENT_SECRET
                                                                                       state:LINKEDIN_STATE
                                                                               grantedAccess:LINKEDIN_ACCESS
                                            ];

    return [LIALinkedInHttpClient clientForApplication:application presentingViewController:nil];
}

@end

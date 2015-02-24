//
//  MSRecording.m
//  MeetScript
//
//  Created by Shane Rogers on 2/24/15.
//  Copyright (c) 2015 SDR. All rights reserved.
//

#import "MSRecording.h"
#import "JSONModel.h"

@protocol MSRecording @end

@implementation MSRecording : JSONModel

@property (nonatomic) NSNumber *id;
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSString *s3URL;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSNumber *organizationId;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *secondName;

@end
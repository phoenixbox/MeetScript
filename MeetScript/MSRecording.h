//
//  MSRecording.h
//  MeetScript
//
//  Created by Shane Rogers on 2/24/15.
//  Copyright (c) 2015 SDR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSRecording : NSObject

+(JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"id",
                                                       @"title": @"title",
                                                       @"s3_url": @"s3URL",
                                                       @"created_at": @"createdAt",
                                                       @"zip_code": @"zipCode",
                                                       @"user.id": @"userId",
                                                       @"user.first_name": @"firstName",
                                                       @"user.second_name": @"secondName"
                                                       @"organization.id": @"organizationId",
                                                       }];
}


@end

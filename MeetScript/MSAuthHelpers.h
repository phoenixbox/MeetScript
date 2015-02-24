//
//  MSAuthStore.h
//  MeetScript
//
//  Created by Shane Rogers on 2/24/15.
//  Copyright (c) 2015 SDR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSAuthHelpers : NSObject

+ (NSString *)authenticateRequest:(NSString *)requestURL;

@end

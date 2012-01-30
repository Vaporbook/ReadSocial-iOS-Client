//
//  AuthStatusRequest.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/24/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "AuthStatusRequest.h"

@implementation AuthStatusRequest

+ (id) status
{
    AuthStatusRequest *request = [AuthStatusRequest new];
    [request start];
    return request;
}

+ (NSURL *) loginURL
{
    NSString *url = [NSString stringWithFormat:@"%@/v1/%d/auth/login", kAPIURL, 8];
    return [NSURL URLWithString:url];
}

+ (NSURL *) statusURL
{
    NSString *url = [NSString stringWithFormat:@"%@/v1/%d/auth/status", kAPIURL, 8];
    return [NSURL URLWithString:url];
}

- (NSMutableURLRequest *) createRequest
{
    NSMutableURLRequest *request = [super createRequest];
    
    // Set the URL
    NSString *url = [NSString stringWithFormat:@"%@/v1/%d/auth/status", kAPIURL, networkId];
    [request setURL:[NSURL URLWithString:url]];
    
    return request;
}

- (void) responseReceived
{
    [super responseReceived];
    NSLog(@"Auth status: %@", responseJSON);
}

@end

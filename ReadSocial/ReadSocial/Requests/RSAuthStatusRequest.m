//
//  RSAuthStatusRequest.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/24/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSAuthStatusRequest.h"

@implementation RSAuthStatusRequest
@synthesize authed, user;

+ (id) requestAuthStatusWithDelegate: (id<RSAPIRequestDelegate>) delegate
{
    RSAuthStatusRequest *request = [RSAuthStatusRequest new];
    request.delegate = delegate;
    [request start];
    return request;
}

+ (id) requestAuthStatus
{
    return [RSAuthStatusRequest requestAuthStatusWithDelegate:nil];
}

# pragma mark - RSAPIRequest Overriden Methods
- (NSMutableURLRequest *) createRequest
{
    NSMutableURLRequest *request = [super createRequest];
    
    // Set the URL
    NSString *url = [NSString stringWithFormat:@"%@/v1/%@/auth/status", ReadSocialAPIURL, networkID];
    [request setURL:[NSURL URLWithString:url]];
    
    return request;
}

- (BOOL) handleResponse:(id)json error:(NSError *__autoreleasing *)error
{
    [super handleResponse:json error:error];
    
    authed  =   [[json valueForKey:@"authed"] boolValue];
    user    =   [json objectForKey:@"user"];
    
    return NO;
}

@end

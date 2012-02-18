//
//  AuthStatusRequest.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/24/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "AuthStatusRequest.h"

@implementation AuthStatusRequest
@synthesize authed;

+ (id) requestAuthStatusWithDelegate: (id<RSAPIRequestDelegate>) delegate
{
    AuthStatusRequest *request = [AuthStatusRequest new];
    request.delegate = delegate;
    [request start];
    return request;
}

+ (id) requestAuthStatus
{
    return [AuthStatusRequest requestAuthStatusWithDelegate:nil];
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

- (void) handleResponse:(id)json error:(NSError *__autoreleasing *)error
{
    [super handleResponse:json error:error];
    
    authed = [[json valueForKey:@"authed"] boolValue];
}

@end

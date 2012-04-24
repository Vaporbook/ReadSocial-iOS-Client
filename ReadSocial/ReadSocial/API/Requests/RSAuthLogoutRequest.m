//
//  RSAuthLogoutRequest.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 4/23/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSAuthLogoutRequest.h"
#import "ReadSocial.h"

@implementation RSAuthLogoutRequest

+ (RSAuthLogoutRequest *) logout
{
    return [RSAuthLogoutRequest logoutWithDelegate:nil];
}
+ (RSAuthLogoutRequest *) logoutWithDelegate: (id<RSAPIRequestDelegate>)delegate
{
    RSAuthLogoutRequest *request = [RSAuthLogoutRequest new];
    request.delegate = delegate;
    [request start];
    return request;
}

# pragma mark - RSAPIRequest Overriden Methods
- (RSMutableURLRequest *) createRequest
{
    RSMutableURLRequest *request = [super createRequest];
    
    // Set the URL
    NSString *url = [NSString stringWithFormat:@"%@/v1/%@/auth/logout", apiURL, networkID];
    [request setURL:[NSURL URLWithString:url]];
    
    [request setHTTPMethod:@"POST"];
    
    return request;
}

- (BOOL) handleResponse:(id)data error:(NSError *__autoreleasing *)error
{
    [[ReadSocial sharedInstance] userDidLogout];
    return NO;
}

@end

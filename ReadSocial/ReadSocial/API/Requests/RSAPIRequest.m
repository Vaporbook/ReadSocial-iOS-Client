//
//  RSAPIRequest.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/24/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSAPIRequest.h"
#import "JSONKit.h"
#import "RSAuthentication.h"
#import "ReadSocial.h"
#import "ReadSocialAPIConfig.h"
#import "NSData+RSBase64.h"
#import "RSUser+Core.h"

static NSString *userAgent;

@interface RSAPIRequest ()

// Prepares response for delegate
- (void) didStartRequest;
- (void) requestDidSucceed;
- (void) requestDidFailWithError: (NSError *)error;

@end;

@implementation RSAPIRequest
@synthesize delegate, receivedError, active;

+ (void) initialize
{
    userAgent = [ReadSocialAPIConfig userAgent];
}

- (id) init
{
    self = [super init];
    if (self)
    {
        apiURL          =   [ReadSocial sharedInstance].apiURL;
        networkID       =   [ReadSocial networkID];
        group           =   [ReadSocial currentGroup];
        appKey          =   [ReadSocial sharedInstance].appKey;
        appSecret       =   [ReadSocial sharedInstance].appSecret;
        receivedError   =   NO;
        active          =   NO;
        connection      =   nil;
    }
    return self;
}

- (RSMutableURLRequest *)createRequest
{
    RSMutableURLRequest *request = [RSMutableURLRequest new];
    
    // Get the cookies for the API
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:apiURL];
    [request setAllHTTPHeaderFields:[NSHTTPCookie requestHeaderFieldsWithCookies:cookies]];
    
    // Add additional header values
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    assumeJSONResponse = YES;
    usingAuthHeaders = NO;
    
    // Check if authorization headers need to be added
    if (appKey && appSecret)
    {
        NSString *credentials = [NSString stringWithFormat:@"%@:%@", appKey, appSecret];
        NSString *encodedCredentials = [[credentials dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString];
        // Remove line breaks from encoded string
        encodedCredentials = [[encodedCredentials componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
        [request addValue:[NSString stringWithFormat:@"Basic %@", encodedCredentials] forHTTPHeaderField:@"Authorization"];
        usingAuthHeaders = YES;
    }
    
    return request;
}

- (void) start
{
    RSMutableURLRequest *request = [self createRequest];
    
    responseData = [NSMutableData data];
    
    NSLog(@"Sending request to: %@", [request URL]);
    
    // Check the URL for "(null)" indicating that the request is invalid
    if ([[[request URL] absoluteString] rangeOfString:@"(null)"].location != NSNotFound) 
    {
        NSLog(@"Invalid request!");
        [self requestDidFailWithError:[NSError errorWithDomain:@"Invalid request." code:0 userInfo:nil]];
        return;
    }
    
    // If we are using auth headers and this is a POST request, then the payload MUST include user data
    // If it doesn't then the request fails.
    if (usingAuthHeaders && [request.HTTPMethod isEqualToString:@"POST"])
    {
        // Check the payload for user data--only check for user id
        NSDictionary *payload;
        if (request.HTTPBody)
        {
            payload = [[JSONDecoder decoder] objectWithData:request.HTTPBody];
        }
        
        if (![payload valueForKey:kUserId])
        {
            [self requestDidFailWithError:[NSError errorWithDomain:@"User not logged in" code:0 userInfo:nil]];
            return;
        }
    }
    
    sentTime = [NSDate date];
    [self didStartRequest];
    connection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    active = YES;
}

- (void) cancel
{
    // Don't do anything if the request is not active
    if (!active)
    {
        return;
    }
    
    NSLog(@"Connection cancelled.");
    [connection cancel];
    active = NO;
}

- (void) failRequestWithError:(NSError *)error
{
    [self requestDidFailWithError:error];
    [self cancel];
}

- (BOOL) handleResponse: (id)data error: (NSError**)error
{
    // Expecting this method to get overridden
    NSLog(@"Response: %@", data);
    return NO;
}

- (void) didStartRequest
{
    if ([delegate respondsToSelector:@selector(didStartRequest:)])
    {
        [delegate didStartRequest:self];
    }
}

- (void) requestDidSucceed
{
    if (receivedError)
    {
        return;
    }
    
    if ([delegate respondsToSelector:@selector(requestDidSucceed:)])
    {
        [delegate requestDidSucceed:self];
    }
}

- (void) requestDidFailWithError: (NSError *)error
{
    receivedError = YES;
    if ([delegate respondsToSelector:@selector(requestDidFail:withError:)])
    {
        [delegate requestDidFail:self withError:error];
    }
}


# pragma mark - NSURLConnectionDelegate and NSURLConnectionDataDelegate methods

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    active = NO;
    [self requestDidFailWithError:error];
}

- (void) connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    active = NO;
    auth = [RSAuthentication loginAndReattemptRequest:self];
}

- (void) connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    if ([delegate respondsToSelector:@selector(requestMadeProgress:)])
    {
        [delegate requestMadeProgress:[NSNumber numberWithFloat:((float)totalBytesWritten/(float)totalBytesExpectedToWrite)]];
    }
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [responseData appendData:data];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // It's only expected to receive one response for each request
    // but in the off-chance that another response was received, then the
    // responseData container needs to be cleared out.
    [responseData setLength:0];
    
    // Store the response from the server
    apiResponse = (NSHTTPURLResponse *) response;
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    active = NO;
    // Connection complete
    // Calculate the response time
    NSTimeInterval responseTime = [[NSDate date] timeIntervalSinceDate:sentTime];
    NSLog(@"Time for response: %f seconds", responseTime);
    
    // Get the response code
    NSLog(@"Response Code: %d", [apiResponse statusCode]);
    
    // Check if the user needs to log in
    if ([apiResponse statusCode]==401) 
    {
        auth = [RSAuthentication loginAndReattemptRequest:self];
        return;
    }
    
    // Watch for errors
    NSError *error = nil;
    
    // Save JSON response
    id response;
    if (assumeJSONResponse) 
    {
        // Attempt to parse JSON
        response = [responseData objectFromJSONDataWithParseOptions:JKParseOptionNone error:&error];
    }
    else
    {
        response = responseData;
    }
    
    BOOL contextChanged = NO;
    if (!error)
    {
        contextChanged = [self handleResponse:response error:&error];
    }
    
    // Save the ReadSocial data context
    if (contextChanged)
    {
        [ReadSocial saveContext];
    }
    
    if (error)
    {
        [self requestDidFailWithError:error];
    }
    else
    {
        [self requestDidSucceed];
    }
}

@end

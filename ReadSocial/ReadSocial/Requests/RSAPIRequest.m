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

NSString* const ReadSocialAPIURL = @"https://api.readsocial.net";
static NSString *userAgent;

@interface RSAPIRequest ()

// Prepares response for delegate
- (void) didStartRequest;
- (void) requestDidSucceed;
- (void) requestDidFailWithError: (NSError *)error;

@end;

@implementation RSAPIRequest
@synthesize delegate, receivedError;

+ (void) initialize
{
    // Create a UIWebView to retrieve the user agent
    UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    userAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
}

- (id) init
{
    self = [super init];
    if (self)
    {
        networkID       =   [ReadSocial networkID];
        group           =   [ReadSocial currentGroup];
        receivedError   =   NO;
    }
    return self;
}

- (NSMutableURLRequest *)createRequest
{
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    
    // Get the cookies for the API
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:ReadSocialAPIURL]];
    [request setAllHTTPHeaderFields:[NSHTTPCookie requestHeaderFieldsWithCookies:cookies]];
    
    // Add additional header values
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:userAgent forHTTPHeaderField:@"User-Agent"];
    
    return request;
}

- (void) start
{
    NSURLRequest *request = [self createRequest];
    
    responseData = [NSMutableData data];
    
    NSLog(@"Sending request to: %@", [request URL]);
    
    // Check the URL for "(null)" indicating that the request is invalid
    if ([[[request URL] absoluteString] rangeOfString:@"(null)"].location != NSNotFound) 
    {
        NSLog(@"Invalid request!");
        [self requestDidFailWithError:[NSError errorWithDomain:@"Invalid request." code:0 userInfo:nil]];
        return;
    }
    
    sentTime = [NSDate date];
    [self didStartRequest];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (BOOL) handleResponse: (id)json error: (NSError**)error
{
    // Expecting this method to get overridden
    NSLog(@"Response: %@", json);
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
    [self requestDidFailWithError:error];
}

- (void) connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSError *error = [NSError errorWithDomain:@"API Requested Authentication" code:401 userInfo:nil];
    [self requestDidFailWithError:error];
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
    
    // Save JSON response
    id responseJSON = [responseData objectFromJSONData];
    
    NSError *error;
    BOOL contextChanged = [self handleResponse:responseJSON error:&error];
    
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

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

NSString* const kAPIURL = @"https://api.readsocial.net";

@implementation RSAPIRequest
@synthesize responseJSON, delegate;

- (id) init
{
    self = [super init];
    
    // Set the default values...this is a temporary place for the assignment to happen.
    networkId = 8;
    defaultGroup = @"partner-testing-channel";
    
    return self;
}

// This method should be overridden
- (NSMutableURLRequest *)createRequest
{
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    
    // Get the cookies for the API
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:kAPIURL]];
    [request setAllHTTPHeaderFields:[NSHTTPCookie requestHeaderFieldsWithCookies:cookies]];
    
    // Add additional header values
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"Mozilla/5.0 (iPad; CPU OS 5_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Mobile/9A334" forHTTPHeaderField:@"User-Agent"];
    
    return request;
}

- (void) start
{
    NSURLRequest *request = [self createRequest];
    
    responseData = [NSMutableData data];
    
    //NSLog(@"Headers: %@", [request allHTTPHeaderFields]);
    //NSLog(@"Body: %@", [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding]);
    NSLog(@"Sending request to: %@", [request URL]);
    
    // Check the URL for "(null)" indicating that the request is invalid
    if ([[[request URL] absoluteString] rangeOfString:@"(null)"].location != NSNotFound) 
    {
        NSLog(@"Invalid request!");
        return;
    }
    
    sentTime = [NSDate date];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

// Expecting this method to get overridden
- (void) responseReceived
{
    
}

# pragma mark - NSURLConnectionDelegate and NSURLConnectionDataDelegate methods

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // Failed
    NSLog(@"Failed: %@", error);
}

- (void) connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSLog(@"Failed: %@", @"Requires authentication.");
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Received data
    // Append data
    [responseData appendData:data];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // Received HTTP response (will contain the status code)
    // Reset data
    [responseData setLength:0];
    
    // Set the response
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
    
    if ([apiResponse statusCode]==401) 
    {
        auth = [RSAuthentication loginAndReattemptRequest:self];
        return;
    }
    
    // Save JSON response
    responseJSON = [responseData objectFromJSONData];
    
    [self responseReceived];
}

@end

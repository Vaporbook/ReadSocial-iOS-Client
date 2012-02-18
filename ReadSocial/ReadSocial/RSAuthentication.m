//
//  RSAuthentication.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/29/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSAuthentication.h"
#import "RSAPIRequest.h"
#import "RSLoginViewController.h"
#import "JSONKit.h"
#import "RSUser+Core.h"
#import "RSUserHandler.h"
#import "ReadSocial.h"

NSString* const RSAuthenticationLoginWasSuccessful  =   @"RSloginWasSuccessful";

@interface RSAuthentication ()

- (void) openModalView;
- (void) closeModalView;
- (void) loginWasSuccessfulForUser: (RSUser *)user;
+ (BOOL) isLoginOrStatusURL: (NSURL *) url;

@end

@implementation RSAuthentication
@synthesize failedRequest, loginURL;

+ (id) loginAtURL: (NSURL *)url AndReattemptRequest: (RSAPIRequest *)request
{
    RSAuthentication *auth = [RSAuthentication new];
    
    auth.loginURL = url;
    auth.failedRequest = request;
    [auth openModalView];
    
    return auth;
}

+ (id) loginAndReattemptRequest: (RSAPIRequest *)request
{
    return [RSAuthentication loginAtURL:[RSAuthentication loginURL] AndReattemptRequest:request];
}

+ (id) login
{
    return [RSAuthentication loginAndReattemptRequest:nil];
}

- (id) init
{
    self = [super init];
    if (self)
    {
        loginViewController = [RSLoginViewController new];
        loginViewController.delegate = self;
        loginViewController.webview.delegate = self;
    }
    return self;
}

+ (NSURL *) loginURL
{
    NSString *url = [NSString stringWithFormat:@"%@/v1/%d/auth/login", ReadSocialAPIURL, [ReadSocial networkID]];
    return [NSURL URLWithString:url];
}

+ (NSURL *) statusURL
{
    NSString *url = [NSString stringWithFormat:@"%@/v1/%d/auth/status", ReadSocialAPIURL, [ReadSocial networkID]];
    return [NSURL URLWithString:url];
}

# pragma mark RSLoginViewController Delegate methods
- (void) didCancelLogin
{
    [self closeModalView];
}

# pragma mark UIWebView Delegate Methods
- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // If the request is a login or status URL and was not the last inspected request, intercept and inspect it
    if ([RSAuthentication isLoginOrStatusURL:[request URL]] &&
        ![[request URL] isEqual:[lastInspectedRequest URL]])
    {
        // Intercept the request for inspection
        NSLog(@"Intercepted: %@", [request URL]);
        responseData = [NSMutableData data];
        [NSURLConnection connectionWithRequest:request delegate:self];
        return NO;
    }
    NSLog(@"Loading: %@", [request URL]);
    return YES;
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"Finished loading: %@", [[webView request] URL]);
}

# pragma mark NSURLConnection Delegate Methods
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [responseData appendData:data];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // Received HTTP response (will contain the status code)
    // Reset data
    [responseData setLength:0];
    
    // Set the response
    urlResponse = (NSHTTPURLResponse *) response;
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    lastInspectedRequest = connection.currentRequest;
    
    // Inspect the response and see if it looks like JSON
    // Attempt to convert it to JSON
    NSError *error;
    id jsonResponse = [responseData objectFromJSONDataWithParseOptions:JKParseOptionStrict error:&error];
    
    // If the conversion to JSON failed, then this isn't what we're looking for--pass it through to the webview.
    if (error || !jsonResponse)
    {
        NSLog(@"Not JSON--sending back to webview. Error: %@\nJSON: %@", error, jsonResponse);
        //[loginViewController.webview loadData:responseData MIMEType:urlResponse.MIMEType textEncodingName:urlResponse.textEncodingName baseURL:[connection.currentRequest URL]];
        // Make the request again
        [loginViewController.webview loadRequest:connection.currentRequest];
    }
    else
    {
        NSDictionary *user = [jsonResponse valueForKey:@"user"];
        
        RSUser *authenticatedUser = [RSUserHandler retrieveOrCreateUser:user];
        [self loginWasSuccessfulForUser:authenticatedUser];
    }
}

# pragma mark Private Methods
- (void) openModalView
{
    loginViewController.loginURL = loginURL;
    
    // Find the root view controller
    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    
    // Create a navigation controller wrapper for the login view
    UINavigationController *wrapper = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    wrapper.modalPresentationStyle = UIModalPresentationFormSheet;
    
    // Open the modal view controller in the root view controller
    [rootViewController presentModalViewController:wrapper animated:YES];
}

- (void) closeModalView
{
    // Find the root view controller
    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    
    [rootViewController dismissModalViewControllerAnimated:YES];
}

- (void) loginWasSuccessfulForUser: (RSUser *)user
{
    NSLog(@"%@ has logged in.", user.name);
    
    // Close the modal view
    [self closeModalView];
    
    // Reattempt the failed request
    if (failedRequest)
    {
        NSLog(@"Reattempting failed request.");
        [failedRequest start];
    }
    
    // Notify the application that the user has logged in
    [[NSNotificationCenter defaultCenter] postNotificationName:RSAuthenticationLoginWasSuccessful object:user];
}

+ (BOOL) isLoginOrStatusURL: (NSURL *) url;
{
    return [url isEqual:[RSAuthentication loginURL]] || [url isEqual:[RSAuthentication statusURL]];
}

@end

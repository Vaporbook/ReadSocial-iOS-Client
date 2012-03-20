//
//  RSAuthentication.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/29/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSAuthentication.h"
#import "RSUser+Core.h"
#import "RSUserHandler.h"
#import "ReadSocial.h"

@interface RSAuthentication ()

- (void) openModalView;
- (void) closeModalView;
- (void) loginWasSuccessfulForUser: (RSUser *)user;

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
        loginViewController = [[ReadSocial sharedInstance].readSocialUI getLoginViewControllerWithDelegate:self];
    }
    return self;
}

+ (NSURL *) loginURL
{
    NSString *url = [NSString stringWithFormat:@"%@/v1/%@/auth/login", ReadSocialAPIURL, [ReadSocial networkID]];
    return [NSURL URLWithString:url];
}

+ (NSURL *) completeURL
{
    NSString *url = [NSString stringWithFormat:@"%@/v1/%@/auth/complete", ReadSocialAPIURL, [ReadSocial networkID]];
    return [NSURL URLWithString:url];
}

# pragma mark RSLoginViewController Delegate methods
- (void) didCancelLogin
{
    [self closeModalView];
    
    // If there is a failed request and the user cancelled the login,
    // Mark the request as failed
    if (failedRequest)
    {
        [failedRequest failRequestWithError:[NSError errorWithDomain:@"User needs to log in." code:0 userInfo:nil]];
    }
}

# pragma mark UIWebView Delegate Methods
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"Finished loading: %@", [[webView request] URL]);
    NSLog(@"Headers: %@", [[webView request] allHTTPHeaderFields]);
    
    // Check if the current URL path is the expected complete URL path
    if ([[[[webView request] URL] path] isEqual:[[RSAuthentication completeURL] path]])
    {
        NSLog(@"Reached complete URL!");
        // If we've reached the complete URL, check the authentication status
        [RSAuthStatusRequest requestAuthStatusWithDelegate:self];
    }
}

# pragma mark RSAPIRequest delegate methods
- (void) requestDidSucceed:(RSAuthStatusRequest *)request
{
    NSLog(@"Status check succeeded! Authed: %d", request.authed);
    
    // Verify that the user successfully logged in
    if (request.authed)
    {
        RSUser *user = [RSUserHandler retrieveOrCreateUser: request.user];
        [self loginWasSuccessfulForUser:user];
    }
    else
    {
        [self didCancelLogin];
    }
}

- (void) requestDidFail:(RSAuthStatusRequest *)request withError:(NSError *)error
{
    NSLog(@"Status check failed.");
    [self didCancelLogin];
}

# pragma mark Private Methods
- (void) openModalView
{
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
    [[ReadSocial sharedInstance] userDidLogin:user];
}

@end

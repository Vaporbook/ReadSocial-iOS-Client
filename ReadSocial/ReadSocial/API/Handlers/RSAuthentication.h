//
//  RSAuthentication.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/29/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSAuthProviderSelect.h"
#import "RSAuthStatusRequest.h"

@class RSAPIRequest;
@class RSLoginViewController;

@protocol RSLoginViewControllerDelegate <NSObject>
- (void) didCancelLogin;
@end

@interface RSAuthentication : NSObject <UIWebViewDelegate, RSAPIRequestDelegate, RSAuthProviderLoginDelegate>
{
    RSAuthProviderSelect *loginViewController;
    NSURLRequest *lastInspectedRequest;
    NSHTTPURLResponse *urlResponse;
    NSMutableData *responseData;
}


/**
 Initializes the login process. Immediately opens a modal view for displaying the login form.
 It is expected that the modal view will load the Twitter login page. After a successful login,
 the modal view will close.
 If the request to the login URL responds with a successful authentiation, then the user is already
 logged in and the modal view will automatically close.
 After a successful login, the RSAPIRequest that had failed will be attempted again 
 since the user probably just needed to log in.
 
 @param url The URL to redirect the user to for entering their credentials.
 @param request The RSAPIRequest originally failed due to the user not being logged in.
 @return RSAuthentication reference.
 */

+ (id) loginAtURL: (NSURL *)url AndReattemptRequest: (RSAPIRequest *)request;

/**
 Initializes the login process. Immediately opens a modal view for displaying the login form.
 It is expected that the modal view will load the Twitter login page. After a successful login,
 the modal view will close.
 If the request to the login URL responds with a successful authentiation, then the user is already
 logged in and the modal view will automatically close.
 After a successful login, the RSAPIRequest that had failed will be attempted again 
 since the user probably just needed to log in.
 
 @param request The RSAPIRequest originally failed due to the user not being logged in.
 @return RSAuthentication reference.
 */
+ (id) loginAndReattemptRequest: (RSAPIRequest *)request;

/**
 Equivalent to calling [RSAuthentication loginAndReattemptRequest:nil].
 
 @return RSAuthentication reference.
 */
+ (id) login;

+ (NSURL *) loginURL;
+ (NSURL *) completeURL;

@property (strong, nonatomic) RSAPIRequest *failedRequest;
@property (strong, nonatomic) NSURL *loginURL;

@end
//
//  RSAPIRequest.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/24/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSMutableURLRequest.h"

@protocol RSAPIRequestDelegate;
@class RSAuthentication;

// Creates a request to send to the API
@interface RSAPIRequest : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate> {
    NSURLConnection *connection;
    
    // The API url (received from [ReadSocial sharedSession].apiURL
    NSURL *apiURL;
    
    // The consumer/secret key for the app (received from the shared session)
    NSString *appKey;
    NSString *appSecret;
    BOOL usingAuthHeaders;
    
    // Copy of session variables for request
    // Just in case the session changes in the middle of a request.
    NSNumber *networkID;
    NSString *group;
    
    // Time response sent
    NSDate *sentTime;
    
    // Response
    BOOL assumeJSONResponse;
    NSMutableData *responseData;
    NSHTTPURLResponse *apiResponse;
    
    RSAuthentication *auth;
}

// true when the request is currently active (sending or receiving a response from a server).
@property (nonatomic, readonly) BOOL active;
@property (nonatomic, readonly) BOOL receivedError;
@property (strong, nonatomic) id<RSAPIRequestDelegate> delegate;

- (RSMutableURLRequest *)createRequest;
- (void) start;
- (void) cancel;

/**
 Force a request to fail.
 */
- (void) failRequestWithError: (NSError*)error;

// Returns whether data was changed or not
- (BOOL) handleResponse: (id)data error: (NSError**)error;

@end

@protocol RSAPIRequestDelegate<NSObject>

@optional
- (void) didStartRequest: (RSAPIRequest *)request;
- (void) requestMadeProgress: (NSNumber *)percentComplete;
- (void) requestDidSucceed: (RSAPIRequest *)request;
- (void) requestDidFail: (RSAPIRequest *)request withError: (NSError *)error;

@end
//
//  RSAPIRequest.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/24/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import <Foundation/Foundation.h>

// API URL
extern NSString* const ReadSocialAPIURL;

@protocol RSAPIRequestDelegate;
@class RSAuthentication;

// Creates a request to send to the API
@interface RSAPIRequest : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate> {
    NSURLConnection *connection;
    
    // Copy of session variables for request
    // Just in case the session changes in the middle of a request.
    NSNumber *networkID;
    NSString *group;
    
    // Time response sent
    NSDate *sentTime;
    
    // Response
    NSMutableData *responseData;
    NSHTTPURLResponse *apiResponse;
    
    RSAuthentication *auth;
}

@property (nonatomic, readonly) BOOL receivedError;
@property (strong, nonatomic) id<RSAPIRequestDelegate> delegate;

- (NSMutableURLRequest *)createRequest;
- (void) start;

// Returns whether data was changed or not
- (BOOL) handleResponse: (id)json error: (NSError**)error;

@end

@protocol RSAPIRequestDelegate<NSObject>

@optional
- (void) didStartRequest: (RSAPIRequest *)request;
- (void) requestDidSucceed: (RSAPIRequest *)request;
- (void) requestDidFail: (RSAPIRequest *)request withError: (NSError *)error;

@end
//
//  RSAPIRequest.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/24/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import <Foundation/Foundation.h>

// API URL
extern NSString* const kAPIURL;

@protocol RSAPIRequestDelegate;
@class RSAuthentication;

// Creates a request to send to the API
@interface RSAPIRequest : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate> {
    NSURLConnection *connection;
    int networkId;
    NSString *defaultGroup; // TODO: This will be moved to app level
    
    // Time response sent
    NSDate *sentTime;
    
    // Response
    NSMutableData *responseData;
    NSHTTPURLResponse *apiResponse;
    id responseJSON;
    RSAuthentication *auth;
}

@property (nonatomic, retain) NSDictionary *responseJSON;
@property (strong, nonatomic) id<RSAPIRequestDelegate> delegate;

- (NSMutableURLRequest *)createRequest;
- (void) start;
- (void) responseReceived;

@end

@protocol RSAPIRequestDelegate<NSObject>

- (void) requestDidSucceed: (id)arg;
- (void) requestDidFail: (id)arg;

@end
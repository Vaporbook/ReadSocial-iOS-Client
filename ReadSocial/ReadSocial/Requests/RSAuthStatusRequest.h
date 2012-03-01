//
//  RSAuthStatusRequest.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/24/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSAPIRequest.h"

@interface RSAuthStatusRequest : RSAPIRequest

@property (nonatomic, readonly) BOOL authed;
@property (nonatomic, strong) NSDictionary *user;

+ (id) requestAuthStatus;
+ (id) requestAuthStatusWithDelegate: (id<RSAPIRequestDelegate>) delegate;

@end

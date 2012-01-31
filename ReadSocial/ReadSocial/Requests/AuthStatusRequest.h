//
//  AuthStatusRequest.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/24/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSAPIRequest.h"

@interface AuthStatusRequest : RSAPIRequest

@property (nonatomic, readonly) BOOL authed;

+ (id) requestAuthStatus;
+ (id) requestAuthStatusWithDelegate: (id<RSAPIRequestDelegate>) delegate;

@end

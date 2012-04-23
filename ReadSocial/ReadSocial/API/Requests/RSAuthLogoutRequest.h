//
//  RSAuthLogoutRequest.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 4/23/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSAPIRequest.h"

@interface RSAuthLogoutRequest : RSAPIRequest

+ (RSAuthLogoutRequest *) logout;
+ (RSAuthLogoutRequest *) logoutWithDelegate: (id<RSAPIRequestDelegate>)delegate;

@end

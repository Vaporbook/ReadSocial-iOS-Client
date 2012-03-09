//
//  RSUserImageRequest.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 3/9/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSAPIRequest.h"

@class RSUser;
@interface RSUserImageRequest : RSAPIRequest

@property (nonatomic, strong) RSUser *user;

+ (RSUserImageRequest *) downloadImageForUser:(RSUser *)user withDelegate:(id<RSAPIRequestDelegate>)delegate;
+ (RSUserImageRequest *) downloadImageForUser:(RSUser *)user;

- (RSUserImageRequest *) initWithUser:(RSUser *)user;

@end

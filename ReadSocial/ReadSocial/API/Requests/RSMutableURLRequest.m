//
//  RSMutableURLRequest.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 3/21/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSMutableURLRequest.h"
#import "ReadSocialAPIConfig.h"

NSString static *userAgent;

@implementation RSMutableURLRequest

+ (void) initialize
{
    userAgent   =   [ReadSocialAPIConfig userAgent];
}

- (id) init
{
    self = [super init];
    if (self)
    {
        [self setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    }
    return self;
}

- (id) initWithURL:(NSURL *)URL
{
    self = [super initWithURL:URL];
    if (self)
    {
        [self setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    }
    return self;
}

@end

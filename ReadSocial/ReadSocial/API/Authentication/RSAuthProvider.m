//
//  RSAuthProvider.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 4/23/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSAuthProvider.h"

@implementation RSAuthProvider
@synthesize name, icon, endpoint;

+ (RSAuthProvider *) providerWithName: (NSString *)theName icon:(UIImage *)theIcon andEndpoint:(NSString *)theEndpoint
{
    return [[RSAuthProvider alloc] initWithName:theName icon:theIcon andEndpoint:theEndpoint];
}

- (id) initWithName: (NSString *)theName icon:(UIImage *)theIcon andEndpoint:(NSString *)theEndpoint
{
    self = [self init];
    if (self)
    {
        self.name       =   theName;
        self.icon       =   theIcon;
        self.endpoint   =   theEndpoint;
    }
    return self;
}

@end

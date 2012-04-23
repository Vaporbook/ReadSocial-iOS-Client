//
//  RSAuthProvider.h
//  ReadSocial
//
//  Represents the details of a given authentication provider.
//
//  Created by Daniel Pfeiffer on 4/23/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSAuthProvider : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) NSString *endpoint;

+ (RSAuthProvider *) providerWithName: (NSString *)theName icon:(UIImage *)theIcon andEndpoint:(NSString *)theEndpoint;
- (id) initWithName: (NSString *)theName icon:(UIImage *)theIcon andEndpoint:(NSString *)theEndpoint;

@end

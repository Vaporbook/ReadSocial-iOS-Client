//
//  ReadSocialAPIConfig.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 3/21/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

/**
 If the implementing app does not specifiy a default group,
 use this group as the default group.
 */
#define RSDefaultGroup      @"partner-testing-channel"

/**
 The URL to the ReadSocial API.
 */
#define RSAPIURL            @"https://api.readsocial.net"

/**
 The library name.
 */
#define RSLibraryName       @"ReadSocial"

/**
 The library version.
 */
#define RSLibraryVersion    @"0.5.3"


#import <Foundation/Foundation.h>

@interface ReadSocialAPIConfig : NSObject

/**
 The user agent for all ReadSocial apps will be in the form:
 [App Name]/[App Version] ReadSocial/[ReadSocial Version] [iOS Name]/[iOS version] ([Device Name])
 e.g.: "Klatch/1.0 ReadSocial/0.6 iPhone OS/5.0.1 (iPad)"
 */
+ (NSString *) userAgent;

@end
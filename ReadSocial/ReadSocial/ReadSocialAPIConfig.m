//
//  ReadSocialAPIConfig.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 3/21/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "ReadSocialAPIConfig.h"

NSString static *appName;
NSString static *appVersion;
NSString static *iOSName;
NSString static *iOSVersion;
NSString static *deviceType;

@implementation ReadSocialAPIConfig

+ (void) initialize
{
    // Load values in from the info plist dictionary
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    appName     =   [infoDictionary valueForKey:@"CFBundleDisplayName"];
    appVersion  =   [infoDictionary valueForKey:@"CFBundleVersion"];
    
    // Load in device values
    iOSName     =   [[UIDevice currentDevice] systemName];
    iOSVersion  =   [[UIDevice currentDevice] systemVersion];
    deviceType  =   [[UIDevice currentDevice] model];
}

+ (NSString *) userAgent
{
    return [NSString stringWithFormat:@"%@/%@ %@/%@ %@/%@ (%@)", appName, appVersion, RSLibraryName, RSLibraryVersion, iOSName, iOSVersion, deviceType];
}

@end
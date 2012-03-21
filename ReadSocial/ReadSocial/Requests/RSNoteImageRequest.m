//
//  RSNoteImageRequest.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 2/21/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSNoteImageRequest.h"
#import "ReadSocial.h"

@implementation RSNoteImageRequest

+ (NSURL *) URLForImageName: (NSString *) imageName
{
    if (!imageName)
    {
        return nil;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@/v1/%@/images/%@", RSAPIURL, [ReadSocial networkID], imageName];
    return [NSURL URLWithString:url];
}

@end

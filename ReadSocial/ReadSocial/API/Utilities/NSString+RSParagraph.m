//
//  NSString+RSParagraph.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/24/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "NSString+RSParagraph.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (RSParagraph)

- (NSString *) normalize
{
    NSString *normalized = self;
    // 1. Trim
    normalized = [normalized stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // 2. Remove new lines
    normalized = [[normalized componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    
    // 3. Remove hyphens
    normalized = [normalized stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    // 4. Replacing multiple spaces with a single space
    // TODO: This is probably not the most efficient method.
    while ([normalized rangeOfString:@"  "].location!=NSNotFound) 
    {
        normalized = [normalized stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    }
    
    return normalized;
}

- (NSString *) generateHash
{
    const char* str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

- (NSString *) normalizeAndHash
{
    return [[self normalize] generateHash];
}

@end

//
//  NSString+RSParagraph.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/24/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RSParagraph)

/**
 *  Normalize the paragraph--removing double spaces, extra spaces, hyphens, etc.
 */
- (NSString *) normalize;

/**
 *  Generate an MD5 hash of the normalized paragraph.
 */
- (NSString *) generateHash;

/**
 *  Perform the normalize and hashing operations on the string.
 */
- (NSString *) normalizeAndHash;

@end

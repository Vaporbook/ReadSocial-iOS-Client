//
//  RSParagraph+Core.h
//  ReadSocial
//
//  Provides the core functionality for RSParagraph--specifically creating and updating.
//  This functionality is defined in an Objective-C category because RSParagraph is a
//  generated file from the data model--any modifications to that file would be overwritten.
//
//  Created by Daniel Pfeiffer on 1/24/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSParagraph.h"

@interface RSParagraph (Core)

/**
 Creates a paragraph in the default context for the NSString.
 The NSString should be the entire paragraph--this method will normalize
 and hash the paragraph for creating requests to the API. It attempts to pull
 any related data from the store, but the most up to date information needs
 to be requested from the API.
 
 @param raw The raw, unnormallized paragraph content.
 @return A RSParagraph for the raw string.
 */
+ (RSParagraph *) createParagraphInDefaultContextForString: (NSString *)raw;

// this doesn't belong here. move it.
+ (RSParagraph *) paragraphFromHash: (NSString *) hash;

@property (readonly, nonatomic, getter=getNormalizedParagraph) NSString *normalized;

@end

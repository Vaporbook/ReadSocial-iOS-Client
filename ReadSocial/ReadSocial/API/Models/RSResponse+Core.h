//
//  RSResponse+Core.h
//  ReadSocial
//
//  Provides the core functionality for RSResponse--specifically creating and updating.
//  This functionality is defined in an Objective-C category because RSResponse is a
//  generated file from the data model--any modifications to that file would be overwritten.
//
//  Created by Daniel Pfeiffer on 1/24/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSResponse.h"

extern NSString* const kResponseId;
extern NSString* const kResponseBody;
extern NSString* const kResponseLink;
extern NSString* const kResponseCreated;
extern NSString* const kResponseNoteId;

@interface RSResponse (Core)

/**
 Creates an RSResponse object and saves it to the store with data contained in the NSDictionary.
 Expects that the keys in the NSDictionary match up with the constants
 defined in this file ("_id", "body", etc.).
 
 @param args The NSDictionary containing Response data retrieved from the API.
 @return The newly created RSResponse object.
 */
+ (RSResponse *) responseFromDictionary: (NSDictionary *)args;

/**
 Updates the RSResponse with data in the NSDictionary. It does not update the id since
 that should never change. This does NOT save the changes in the context--it only makes
 the changes on the scratchpad--it is the responsibility of the caller to save changes.
 
 @param args NSDictionary with data about the response.
 */
- (void) updateResponseWithDictionary: (NSDictionary *)args;

@end

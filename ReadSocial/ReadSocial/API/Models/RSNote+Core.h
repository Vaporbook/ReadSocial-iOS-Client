//
//  RSNote+Core.h
//  ReadSocial
//
//  Provides the core functionality for RSNote--specifically creating and updating.
//  This functionality is defined in an Objective-C category because RSNote is a
//  generated file from the data model--any modifications to that file would be overwritten.
//  
//  Created by Daniel Pfeiffer on 1/24/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSNote.h"

extern NSString* const kNoteId;
extern NSString* const kNoteBody;
extern NSString* const kNoteType;
extern NSString* const kNoteLink;
extern NSString* const kNoteThumbnail;
extern NSString* const kNoteImage;
extern NSString* const kNoteCreated;
extern NSString* const kNoteParagraphHash;
extern NSString* const kHighlightedText;

@interface RSNote (Core)

/**
 Creates an RSNote object and saves it to the store with data contained in the NSDictionary.
 Expects that the keys in the NSDictionary match up with the constants
 defined in this file ("_id", "body", etc.).
 
 @param args The NSDictionary containing Note data retrieved from the API.
 @return The newly created RSNote object.
 */
+ (RSNote *) noteFromDictionary: (NSDictionary *)args;

/**
 Updates the RSNote with data in the NSDictionary. It does not update the note id since
 that should never change. This does NOT save the changes in the context--it only makes
 the changes on the scratchpad--it is the responsibility of the caller to save changes.
 
 @param args NSDictionary with data about the note.
 */
- (void) updateNoteWithDictionary: (NSDictionary *)args;

@end

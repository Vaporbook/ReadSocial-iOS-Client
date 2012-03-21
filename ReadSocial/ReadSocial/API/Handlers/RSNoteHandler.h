//
//  RSNoteHandler.h
//  ReadSocial
//
//  Responsible for handling note objects--retrieves notes from the persistent store
//  and updates the persistent store from data retrieved from the API.
//  This class is not intended to be instantiated, rather it is intended for taking care
//  common tasks related to Notes.
//
//  Created by Daniel Pfeiffer on 1/24/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RSParagraph;
@class RSNote;
@interface RSNoteHandler : NSObject

/**
 Immediately pulls all notes for a paragraph from the local store and places the
 notes in an NSArray sorted by timestamp descending.
 Note: This content may be outdated based on when the last time the local store
 was updated. The best thing to do is to get the stale data from the local store
 and immediately request updated data using [RSResponseHandler updateNotesForParagraph].
 
 @param paragraph The RSParagraph object.
 @return An NSArray of RSNote's for the paragraph (for the active group only).
 */
+ (NSArray *) notesForParagraph: (RSParagraph *)paragraph;

/**
 
 Note that this does not save the context! It is the responsibility of the caller to save the context.
 
 @param paragraph The paragraph for which to fetch responses.
 */
+ (void) updateNotesForParagraph: (RSParagraph *)paragraph;

+ (RSNote *) updateOrCreateNoteWithDictionary: (NSDictionary *)data;

/**
 Updates/creates Note objects in the persistent store with the contents of an NSArray.
 Expects that each NSDictionary object declares the "_id" property.
 
 @param notes The NSArray should contain NSDictionary elements with data retrieved from the API.
 @param paragraph The RSParagraph the notes belong to.
 */
+ (void) updateOrCreateNotesWithArray: (NSArray *)notes forParagraph:(RSParagraph *)paragraph;

/**
 Retrieves an NSArray of RSNote objects for each note ID specified.
 @param ids An NSArray of note ids to retrieve from the store.
 @return An NSArray of RSNote objects that matched the note ids.
 
 I don't think that the return will neccessarily respond in the same order as specified in the parameter.
 */
+ (NSArray *) notesForIds: (NSArray *)ids;

/**
 Retrieves a single note from the store.
 
 @param id An NSString containing the ID of the note to retrieve.
 @return The NSNote object matching the ID or nil if it could not be found.
 @discussion This function does NOT make a request to the API for the note if it could not be found--it only looks in the local store.
 */
+ (RSNote *) noteForId: (NSString *)id;

@end

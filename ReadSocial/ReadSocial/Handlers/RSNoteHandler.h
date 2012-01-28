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

@class RSNote;
@interface RSNoteHandler : NSObject

/**
 Updates/creates Note objects in the persistent store with the contents of an NSArray.
 Expects that each NSDictionary object declares the "_id" property.
 
 @param notes The NSArray should contain NSDictionary elements with data retrieved from the API.
 */
+ (void) updateOrCreateNotesWithArray: (NSArray *)notes;

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

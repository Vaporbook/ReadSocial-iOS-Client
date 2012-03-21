//
//  RSResponseHandler.h
//  ReadSocial
//
//  Responsible for handling RSResponse objects--retrieves responses from the persistent store
//  and updates the persistent store from data retrieved from the API.
//  This class is not intended to be instantiated, rather it is intended for taking care
//  common tasks related to responses.
//
//  Created by Daniel Pfeiffer on 1/24/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RSNote;
@class RSResponse;

@interface RSResponseHandler : NSObject

+ (RSResponse *) updateOrCreateResponseWithDictionary: (NSDictionary *)data;

/**
 Immediately pulls all responses for a note from the local store and places the
 responses in an NSArray sorted by timestamp descending.
 Note: This content may be outdated based on when the last time the local store
 was updated. The best thing to do is to get the stale data from the local store
 and immediately request updated data using [RSResponseHandler updateResponsesForNote].
 
 @param note The RSNote object.
 @return An NSArray of RSResponse's for the note.
 */
+ (NSArray *) responsesForNote: (RSNote *)note;
+ (NSArray *) responsesForNote:(RSNote *)note before:(NSDate *)timestamp;

/**
 Updates/creates RSResponse objects in the persistent store with the contents of an NSArray.
 Expects that each NSDictionary object declares the "_id" property.
 
 @param notes The NSArray should contain NSDictionary elements with data retrieved from the API.
 */
+ (void) updateOrCreateResponsesWithArray: (NSArray *)responses forNote:(RSNote *)note;

+ (RSResponse *) responseForId: (NSString *)id;

/**
 Retrieves an NSArray of RSResponse objects for each response ID specified.
 @param ids An NSArray of response ids to retrieve from the store.
 @return An NSArray of RSResponse objects that matched the ids.
 
 I don't think that the return will neccessarily respond in the same order as specified in the parameter.
 */
+ (NSArray *) responsesForIds: (NSArray *)ids;

@end

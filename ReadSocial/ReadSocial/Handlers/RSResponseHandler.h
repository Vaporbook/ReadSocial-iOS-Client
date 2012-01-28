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

@interface RSResponseHandler : NSObject

/**
 Immediately pulls all the responses for the specified note from the persistent store
 and initiates a request to the API to update the persitent store. Once the new data is
 available, all referencing objects will automatically be updated and any views should
 refresh their data.
 
 @param note The RSNote object.
 @return An NSArray of RSResponse's for the note.
 */
+ (NSArray *) responsesForNote: (RSNote *)note;

/**
 Updates/creates RSResponse objects in the persistent store with the contents of an NSArray.
 Expects that each NSDictionary object declares the "_id" property.
 
 @param notes The NSArray should contain NSDictionary elements with data retrieved from the API.
 */
+ (void) updateOrCreateResponsesWithArray: (NSArray *)responses;

/**
 Retrieves an NSArray of RSResponse objects for each response ID specified.
 @param ids An NSArray of response ids to retrieve from the store.
 @return An NSArray of RSResponse objects that matched the ids.
 
 I don't think that the return will neccessarily respond in the same order as specified in the parameter.
 */
+ (NSArray *) responsesForIds: (NSArray *)ids;

/**
 Creates a response for a note and sends the data to the API.
 Once the response is received, updates the local store with the new response.
 
 @param content The NSString containing the content of the response.
 @param note The RSNote the response is responding to.
 */
+ (void) createResponse: (NSString*)content forNote:(RSNote*)note;

@end

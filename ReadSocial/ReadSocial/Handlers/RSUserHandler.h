//
//  RSUserHandler.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/29/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RSUser;
@interface RSUserHandler : NSObject

/**
 Updates/creates User objects in the persistent store with the contents of an NSArray.
 Expects that each NSDictionary object declares the "uid" property.
 
 @param notes The NSArray should contain NSDictionary elements with data retrieved from the API.
 */
+ (void) updateOrCreateUsersWithArray: (NSArray *)users;

/**
 Retrieves an NSArray of RSUser objects for each user ID specified.
 @param ids An NSArray of user ids to retrieve from the store.
 @return An NSArray of RSUser objects that matched the note ids.
 
 I don't think that the return will neccessarily respond in the same order as specified in the parameter.
 */
+ (NSArray *) usersForIds: (NSArray *)ids;

/**
 Retrieves a single user from the store.
 
 @param id An NSString containing the ID of the user to retrieve.
 @return The RSUser object matching the ID or nil if it could not be found.
 @discussion This function does NOT make a request to the API for the note if it could not be found--it only looks in the local store.
 */
+ (RSUser *) userForID: (NSString *)id;

/**
 Attempts to retrieve a user with the ID found in the arguments;
 creates a new user if one couldn't be found.
 If the user was found, it updates the user info with the data in the dictionary.
 
 @param args An NSDictionary containing user arguments (received from API).
 @return RSUser--either retrieved from the store or a new one.
 */
+ (RSUser *) retrieveOrCreateUser: (NSDictionary *)args;

@end

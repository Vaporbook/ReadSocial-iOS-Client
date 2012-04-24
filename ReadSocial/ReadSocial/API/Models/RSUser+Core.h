//
//  RSUser+Core.h
//  ReadSocial
//
//  Provides the core functionality for RSUser--specifically creating and updating.
//  This functionality is defined in an Objective-C category because RSResponse is a
//  generated file from the data model--any modifications to that file would be overwritten.
//
//  Created by Daniel Pfeiffer on 1/29/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSUser.h"

extern NSString* const kUserId;
extern NSString* const kUserName;
extern NSString* const kUserImage;
extern NSString* const kUserDomain;

@class RSUserImageRequest;
@interface RSUser (Core)

@property (nonatomic, readonly, getter = getImage) UIImage *image;
@property (readonly, getter = getImageIsDownloaded) BOOL imageIsDownloaded;
@property (nonatomic, readonly) NSDictionary *dictionary;

/**
 Creates a RSUser object from data in an NSDictionary.
 Expects that the keys in the NSDictionary match up with the constants
 defined in this file ("uid", "uname", etc.).
 
 @param args The NSDictionary containing Response data retrieved from the API.
 @return The newly created RSUser object.
 */
+ (RSUser *) userWithDictionary: (NSDictionary *)args;

/**
 Creates a new user object with a custom ID, name, image, and domain.
 
 @param id  The user's identification number.
 @param name The user's name (could be a screenname or user name).
 @param imageURL URL to the user's profile image.
 @param domain The domain the user belongs to.
 @return The newly created RSUser object.
 */
+ (RSUser *) userWithID:(NSNumber *)uid andName:(NSString *)name andImageURL:(NSURL *)imageURL forDomain:(NSString *)domain;

/**
 Updates the RSUser with data in the NSDictionary. It does not update the uid since
 that should never change. This does NOT save the changes in the context--it only makes
 the changes on the scratchpad--it is the responsibility of the caller to save changes.
 This will update the "updated" property on the user so the context knows the last time
 the object was updated from the API--it will only re-download the image data if the cache
 data is over a week old.
 
 @param args NSDictionary with data about the user.
 @return YES if changes were made to the user, NO if no changes were made.
 */
- (BOOL) updateUserWithDictionary: (NSDictionary *)args;

@end

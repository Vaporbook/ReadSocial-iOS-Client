//
//  RSUserHandler.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/29/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSUserHandler.h"
#import "DataContext.h"
#import "RSUser+Core.h"

@implementation RSUserHandler

+ (void) updateOrCreateUsersWithArray: (NSArray *)users
{
    // Get an array of all the IDs that need to be saved
    // This also checks for duplicate users in the passed parameter
    // and removes those duplicates
    NSMutableArray *ids = [NSMutableArray array];
    NSMutableArray *filteredUsers = [NSMutableArray array];
    for (NSDictionary *pUser in users)
    {
        NSNumber *uid = [pUser valueForKey:kUserId];
        
        // Only add this user if it hasn't been tracked
        if ([ids indexOfObject:uid]==NSNotFound)
        {
            [ids addObject:[pUser valueForKey:kUserId]];
            [filteredUsers addObject:pUser];
        }
    }
    
    // Replace the parameter with the filtered parameter
    users = filteredUsers;
    
    // Fetch notes currently in the store with the same ID
    NSArray *fetchedItems = [RSUserHandler usersForIds:ids];
    
    // Sort users parameter by user id
    users = [users sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"uid" ascending:YES]]];
    
    // Retrieve the first object in each array
    NSEnumerator *fetchedEnumerator = [fetchedItems objectEnumerator];
    NSEnumerator *responseEnumerator = [users objectEnumerator];
    RSUser *fetchedItem = [fetchedEnumerator nextObject];
    NSDictionary *item  = [responseEnumerator nextObject];
    
    // Walk through the arrays
    while (item || fetchedItem)
    {
        // If the IDs are equal on the fetched note (the one from the store) and the note
        // received from the API, then the note is already stored--just need to update it.
        if ([fetchedItem.uid intValue]==[[item valueForKey:kUserId] intValue]) 
        {
            NSLog(@"Update user: %@", fetchedItem.uid);
            [fetchedItem updateUserWithDictionary:item];
            
            // Next notes
            item        = [responseEnumerator nextObject];
            fetchedItem = [fetchedEnumerator nextObject];
        }
        
        // If there is a note object that doesn't match the current fetchedNote
        // then it is a new note; insert it into the context.
        else if (item)
        {
            NSLog(@"Create a new user: %@", [item valueForKey:kUserId]);
            [RSUser userWithDictionary:item];
            
            item = [responseEnumerator nextObject];
        }
    }
    
    [DataContext save];
}

+ (NSArray *) usersForIds: (NSArray *)ids
{
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:[NSEntityDescription entityForName:@"RSUser" inManagedObjectContext:[DataContext defaultContext]]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"(uid in %@)", ids]];
    
    // Sort by user id
    [request setSortDescriptors:[NSArray arrayWithObjects:[[NSSortDescriptor alloc] initWithKey:@"uid" ascending:YES],nil]];
    
    NSArray *fetchedResponses = [[DataContext defaultContext] executeFetchRequest:request error:nil];
    
    return fetchedResponses;
}

+ (RSUser *) userForID: (NSString *)id
{
    NSArray *users = [RSUserHandler usersForIds:[NSArray arrayWithObject:id]];
    
    if (!users || [users count]==0)
    {
        return nil;
    }
    
    return [users objectAtIndex:0];
}

+ (RSUser *) retrieveOrCreateUser: (NSDictionary *)args
{
    // First attempt to retrieve the user
    RSUser *user = [RSUserHandler userForID:[args valueForKey:kUserId]];
    
    // If a user was found, update the user information and return the updated object
    if (user)
    {
        if ([user updateUserWithDictionary:args])
        {
            [DataContext save];
        }
        return user;
    }
    
    user = [RSUser userWithDictionary:args];
    [DataContext save];
    
    return user;
}

@end

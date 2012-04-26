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
        NSString *uid = [pUser valueForKey:kUserId];
        
        // Only add this user if it hasn't been tracked
        if ([ids indexOfObject:uid]==NSNotFound)
        {
            [ids addObject:[pUser valueForKey:kUserId]];
            [filteredUsers addObject:pUser];
        }
    }
    
    for (NSDictionary *data in filteredUsers)
    {
        [RSUserHandler retrieveOrCreateUser:data];
    }
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
            
        }
        return user;
    }
    
    user = [RSUser userWithDictionary:args];
    
    return user;
}

@end

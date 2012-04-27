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
    for (NSDictionary *data in users)
    {
        [RSUserHandler retrieveOrCreateUser:data];
    }
}

+ (NSArray *) usersForIds: (NSArray *)ids inDomain:(NSString *)domain
{
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:[NSEntityDescription entityForName:@"RSUser" inManagedObjectContext:[DataContext defaultContext]]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"(uid in %@) AND (udom=%@)", ids, domain]];
    
    // Sort by user id
    [request setSortDescriptors:[NSArray arrayWithObjects:[[NSSortDescriptor alloc] initWithKey:@"uid" ascending:YES],nil]];
    
    NSArray *fetchedResponses = [[DataContext defaultContext] executeFetchRequest:request error:nil];
    
    return fetchedResponses;
}

+ (RSUser *) userForID: (NSString *)id inDomain:(NSString *)domain
{
    NSArray *users = [RSUserHandler usersForIds:[NSArray arrayWithObject:id] inDomain:domain];
    
    if (!users || [users count]==0)
    {
        return nil;
    }
    
    return [users objectAtIndex:0];
}

+ (RSUser *) retrieveOrCreateUser: (NSDictionary *)args
{
    // First attempt to retrieve the user
    RSUser *user = [RSUserHandler userForID:[args valueForKey:kUserId] inDomain:[args valueForKey:kUserDomain]];
    
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

//
//  RSResponseHandler.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/24/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSResponseHandler.h"
#import "RSNote+Core.h"
#import "RSResponse+Core.h"
#import "RSNoteResponsesRequest.h"
#import "DataContext.h"

@implementation RSResponseHandler

+ (NSArray *) responsesForNote: (RSNote *)note
{
    // The responses for the note are already available on the scratchpad as a set
    // The set needs to be sorted by timestamp descending.
    return [note.responses sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO]]];
}

+ (RSResponse *) updateOrCreateResponseWithDictionary: (NSDictionary *)data
{
    RSResponse *response = [RSResponseHandler responseForId:[data valueForKey:kResponseId]];
    
    if (!response)
    {
        response = [RSResponse responseFromDictionary:data];
    }
    else
    {
        [response updateResponseWithDictionary:data];
    }
    
    return response;
}

+ (void) updateOrCreateResponsesWithArray: (NSArray *)responses forNote:(RSNote *)note
{
    // Delete all stored responses with a date prior to the date on the
    // first response received from the API.
    
    // Get a reference to all the cached responses on this note
    NSArray *oldResponses;
    
    // Check if there are new responses to be downloaded for the note
    if ([responses count]>0)
    {
        // Retrieve the response data for the last updated response
        NSDictionary *lastUpdatedResponseData = [responses objectAtIndex:0];
        RSResponse *lastUpdatedResponse = [RSResponseHandler updateOrCreateResponseWithDictionary:lastUpdatedResponseData];
        
        // Fetch all the responses with a created date prior to this response
        oldResponses = [RSResponseHandler responsesForNote:note before:lastUpdatedResponse.timestamp];
        NSLog(@"Found %d responses before %@ for note: %@", [oldResponses count], lastUpdatedResponse.timestamp, note);
    }
    
    // If responses is nil or empty, then erase all the responses on this note (created before right now...which should be all of them).
    else
    {
        oldResponses = [RSResponseHandler responsesForNote:note before:[NSDate date]];
    }
    
    // Delete all the old responses
    for (RSResponse *oldResponse in oldResponses) 
    {
        [[DataContext defaultContext] deleteObject:oldResponse];
    }
    
    NSLog(@"Deleted %d old responses.", [oldResponses count]);
    
    // Create new responses
    for (NSDictionary *responseData in responses) 
    {
        [RSResponseHandler updateOrCreateResponseWithDictionary:responseData];
    }
    
    NSLog(@"Created %d new responses.", [responses count]);
    
    // The caller MUST save the context otherwise the update will not complete.
}

+ (NSArray *) responsesForNote:(RSNote *)note before:(NSDate *)timestamp
{
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:[NSEntityDescription entityForName:@"RSResponse" inManagedObjectContext:[DataContext defaultContext]]];
    
    [request setPredicate:[NSPredicate predicateWithFormat:@"timestamp < %@ AND note==%@", timestamp, note]];
    
    NSArray *responses = [[DataContext defaultContext] executeFetchRequest:request error:nil];
    return responses;
}

+ (RSResponse *) responseForId: (NSString *)id
{
    NSArray *responses = [RSResponseHandler responsesForIds:[NSArray arrayWithObject:id]];
    
    if (!responses || [responses count]==0)
    {
        return nil;
    }
    
    return [responses objectAtIndex:0];
}

+ (NSArray *) responsesForIds: (NSArray *)ids
{
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:[NSEntityDescription entityForName:@"RSResponse" inManagedObjectContext:[DataContext defaultContext]]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"(id in %@)", ids]];
    
    // Sort by timestamp--the response from the server should be ordered by timestamp (descending)
    [request setSortDescriptors:[NSArray arrayWithObjects:[[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO],[[NSSortDescriptor alloc] initWithKey:@"id" ascending:NO],nil]];
    
    NSArray *fetchedResponses = [[DataContext defaultContext] executeFetchRequest:request error:nil];
    
    return fetchedResponses;
}

@end

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
#import "NoteResponsesRequest.h"
#import "CreateNoteResponseRequest.h"
#import "DataContext.h"

@implementation RSResponseHandler

+ (NSArray *) responsesForNote: (RSNote *)note
{
    [NoteResponsesRequest responsesForNote:note];
    return [note.responses allObjects];
}

+ (void) updateOrCreateResponsesWithArray: (NSArray *)responses
{
    // Get an array of all the IDs that need to be saved
    NSMutableArray *ids = [NSMutableArray array];
    for (NSDictionary *pResponse in responses)
    {
        [ids addObject:[pResponse valueForKey:kResponseId]];
    }
    
    // Fetch notes currently in the store with the same ID
    NSArray *fetchedItems = [RSResponseHandler responsesForIds:ids];
    
    // Retrieve the first object in each array
    NSEnumerator *fetchedEnumerator = [fetchedItems objectEnumerator];
    NSEnumerator *responseEnumerator = [responses objectEnumerator];
    RSResponse *fetchedItem = [fetchedEnumerator nextObject];
    NSDictionary *item  = [responseEnumerator nextObject];
    
    // Walk through the arrays
    while (item || fetchedItem)
    {
        // If the IDs are equal on the fetched note (the one from the store) and the note
        // received from the API, then the note is already stored--just need to update it.
        if ([fetchedItem.id isEqualToString:[item valueForKey:kResponseId]]) 
        {
            NSLog(@"Update item: %@", fetchedItem.id);
            [fetchedItem updateResponseWithDictionary:item];
            
            // Next notes
            item        = [responseEnumerator nextObject];
            fetchedItem = [fetchedEnumerator nextObject];
        }
        
        // If there is a note object that doesn't match the current fetchedNote
        // then it is a new note; insert it into the context.
        else if (item)
        {
            NSLog(@"Create a new item: %@", [item valueForKey:kResponseId]);
            [RSResponse responseFromDictionary:item];
            
            item = [responseEnumerator nextObject];
        }
    }
    
    // TODO: Delete old notes
    
    [DataContext save];
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

#warning This method needs to update the store when the response is received.
+ (void) createResponse: (NSString*)content forNote:(RSNote*)note
{
    // Create a new request to create a note response
    [CreateNoteResponseRequest createResponse:content forNote:(RSNote *)note];
}

@end

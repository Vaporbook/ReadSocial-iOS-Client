//
//  RSNoteHandler.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/24/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSNoteHandler.h"
#import "RSNote+Core.h"
#import "DataContext.h"

@implementation RSNoteHandler

+ (void) updateOrCreateNotesWithArray: (NSArray *)notes
{
    // Get an array of all the note IDs that need to be saved
    NSMutableArray *note_ids = [NSMutableArray array];
    for (NSDictionary *pNote in notes)
    {
        [note_ids addObject:[pNote valueForKey:kNoteId]];
    }
    
    // Fetch notes currently in the store with the same ID
    NSArray *fetchedNotes = [RSNoteHandler notesForIds:note_ids];
    
    // Retrieve the first object in each array
    NSEnumerator *fetchedNoteEnumerator = [fetchedNotes objectEnumerator];
    NSEnumerator *noteEnumerator = [notes objectEnumerator];
    RSNote *fetchedNote = [fetchedNoteEnumerator nextObject];
    NSDictionary *note  = [noteEnumerator nextObject];
    
    // Walk through the arrays
    while (note || fetchedNote)
    {
        // If the IDs are equal on the fetched note (the one from the store) and the note
        // received from the API, then the note is already stored--just need to update it.
        if ([fetchedNote.id isEqualToString:[note valueForKey:kNoteId]]) 
        {
            NSLog(@"Update note: %@", fetchedNote.id);
            [fetchedNote updateNoteWithDictionary:note];
            
            // Next notes
            note        = [noteEnumerator nextObject];
            fetchedNote = [fetchedNoteEnumerator nextObject];
        }
        
        // If there is a note object that doesn't match the current fetchedNote
        // then it is a new note; insert it into the context.
        else if (note)
        {
            NSLog(@"Create a new note: %@", [note valueForKey:kNoteId]);
            [RSNote noteFromDictionary:note];
            
            note = [noteEnumerator nextObject];
        }
    }
    
    // TODO: Delete old notes
    [DataContext save];
}

+ (NSArray *) notesForIds: (NSArray *)ids
{
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:[NSEntityDescription entityForName:@"RSNote" inManagedObjectContext:[DataContext defaultContext]]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"(id in %@)", ids]];
    
    // Sort by timestamp--the response from the server should be ordered by timestamp (descending)
    [request setSortDescriptors:[NSArray arrayWithObjects:[[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO],[[NSSortDescriptor alloc] initWithKey:@"id" ascending:NO],nil]];
    
    NSArray *fetchedNotes = [[DataContext defaultContext] executeFetchRequest:request error:nil];
    
    return fetchedNotes;
}

+ (RSNote *) noteForId:(NSString *)id
{
    NSArray *notes = [RSNoteHandler notesForIds:[NSArray arrayWithObject:id]];
    
    if (!notes || [notes count]==0)
    {
        return nil;
    }
    
    return [notes objectAtIndex:0];
}

@end

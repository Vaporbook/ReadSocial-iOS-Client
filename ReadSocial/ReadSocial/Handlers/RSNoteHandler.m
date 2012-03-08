//
//  RSNoteHandler.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/24/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSNoteHandler.h"
#import "RSNote+Core.h"
#import "RSParagraph+Core.h"
#import "DataContext.h"
#import "RSParagraphNotesRequest.h"
#import "RSCreateNoteRequest.h"

@interface RSNoteHandler()

+ (NSArray *) notesCreatedBefore: (NSDate *) timestamp;
+ (NSArray *) notesCreatedOnParagraph: (RSParagraph *) paragraph before: (NSDate *) timestamp;

@end;

@implementation RSNoteHandler

+ (NSArray *) notesForParagraph: (RSParagraph *)paragraph
{
    // The notes for the paragraph are already available on the scratchpad as a set
    // The set needs to be sorted by timestamp descending.
    return [paragraph.notes sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO]]];
}

+ (void) updateNotesForParagraph:(RSParagraph *)paragraph
{
    [RSParagraphNotesRequest notesForParagraph:paragraph];
}

+ (RSNote *) updateOrCreateNoteWithDictionary: (NSDictionary *)data
{
    // Attempt to get the note from the store with a matching ID
    RSNote *note = [RSNoteHandler noteForId:[data valueForKey:kNoteId]];
    
    // If no note was found, create a new one
    if (!note) 
    {
        note = [RSNote noteFromDictionary:data];
    }
    
    // Otherwise update the existing note
    else
    {
        [note updateNoteWithDictionary:data];
    }
    
    return note;
}

+ (void) updateOrCreateNotesWithArray: (NSArray *)notes
{
    // Make sure that there are notes
    if ([notes count]==0)
    {
        return;
    }
    
    // Delete all stored notes with a date prior to the date on the
    // first note received from the API.
    
    // Retrieve the note data for the last updated note
    NSDictionary *lastUpdatedNoteData = [notes objectAtIndex:0];
    RSNote *lastUpdatedNote = [RSNoteHandler updateOrCreateNoteWithDictionary:lastUpdatedNoteData];
    
    // Fetch all the notes with a created date prior to this note
    NSArray *oldNotes = [RSNoteHandler notesCreatedOnParagraph:lastUpdatedNote.paragraph before:lastUpdatedNote.timestamp];
    
    // Delete all the old notes
    for (RSNote *oldNote in oldNotes) 
    {
        [[DataContext defaultContext] deleteObject:oldNote];
    }
    
    NSLog(@"Deleted %d old notes.", [oldNotes count]);
    
    // Create new notes
    for (NSDictionary *noteData in notes) 
    {
        [RSNote noteFromDictionary:noteData];
    }
    
    NSLog(@"Created %d new notes.", [notes count]);
    
    // The caller MUST save the context otherwise the update will not complete.
}

+ (NSArray *) notesCreatedBefore: (NSDate *) timestamp
{
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:[NSEntityDescription entityForName:@"RSNote" inManagedObjectContext:[DataContext defaultContext]]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"timestamp <= %@", timestamp]];
    
    NSArray *notes = [[DataContext defaultContext] executeFetchRequest:request error:nil];
    return notes;
}

+ (NSArray *) notesCreatedOnParagraph:(RSParagraph *) paragraph before:(NSDate *) timestamp
{
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:[NSEntityDescription entityForName:@"RSNote" inManagedObjectContext:[DataContext defaultContext]]];
    
    [request setPredicate:[NSPredicate predicateWithFormat:@"timestamp <= %@ AND paragraph==%@", timestamp, paragraph]];
    
    NSArray *notes = [[DataContext defaultContext] executeFetchRequest:request error:nil];
    return notes;
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

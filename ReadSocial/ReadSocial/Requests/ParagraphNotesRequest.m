//
//  ParagraphNotesRequest.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/24/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "ParagraphNotesRequest.h"
#import "RSParagraph+Core.h"
#import "RSNoteHandler.h"
#import "RSUserHandler.h"

@implementation ParagraphNotesRequest

+ (id) notesForParagraph: (RSParagraph *)paragraph
{
    ParagraphNotesRequest *request = [[ParagraphNotesRequest alloc] initWithParagraph:paragraph];
    [request start];
    return request;
}

- (id) initWithParagraph: (RSParagraph *)paragraph
{
    self = [super init];
    _paragraph = paragraph;
    return self;
}

- (NSMutableURLRequest *) createRequest
{
    NSMutableURLRequest *request = [super createRequest];
    
    // Determine the URL
    NSString *url = [NSString stringWithFormat:@"%@/v1/%d/%@/notes?par_hash=%@", kAPIURL, networkId, defaultGroup, _paragraph.par_hash];
    
    [request setURL:[NSURL URLWithString:url]];
    
    return request;
}

- (void) responseReceived
{
    [super responseReceived];
    
    // ResponseJSON should be an NSArray
    if (![responseJSON isKindOfClass:[NSArray class]])
    {
        [NSException raise:@"Invalid Response" format:@"Invalid response received from API; expecting an array.\n%@", responseJSON];
    }
    // Create notes
    NSArray *notes = (NSArray *)responseJSON;
    
    //NSLog(@"Notes:\n%@", notes);
    
    // Update the note count for the paragraph
    _paragraph.noteCount = [NSNumber numberWithInt:[notes count]];
    
    // First, update user data
    [RSUserHandler updateOrCreateUsersWithArray:notes];
    
    // Then update the note data
    [RSNoteHandler updateOrCreateNotesWithArray:notes];
}

@end

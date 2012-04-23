//
//  RSParagraphNotesRequest.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/24/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSParagraphNotesRequest.h"
#import "RSNoteCountRequest.h"
#import "RSParagraph+Core.h"
#import "RSNoteHandler.h"
#import "RSUserHandler.h"

@implementation RSParagraphNotesRequest
@synthesize paragraph=_paragraph, before;

+ (RSParagraphNotesRequest *) notesForParagraph: (RSParagraph *)paragraph beforeDate:(NSDate *)before withDelegate: (id<RSAPIRequestDelegate>)delegate
{
    RSParagraphNotesRequest *request = [[RSParagraphNotesRequest alloc] initWithParagraph:paragraph];
    request.before = before;
    request.delegate = delegate;
    [request start];
    return request;
}

+ (RSParagraphNotesRequest *) notesForParagraph: (RSParagraph *)paragraph withDelegate: (id<RSAPIRequestDelegate>)delegate
{
    return [RSParagraphNotesRequest notesForParagraph:paragraph beforeDate:nil withDelegate:delegate];
}

+ (RSParagraphNotesRequest *) notesForParagraph: (RSParagraph *)paragraph
{
    return [RSParagraphNotesRequest notesForParagraph:paragraph withDelegate:nil];
}

- (RSParagraphNotesRequest *) initWithParagraph: (RSParagraph *)paragraph
{
    self = [super init];
    if (self)
    {
        _paragraph = paragraph;
    }
    return self;
}

# pragma mark - RSAPIRequest Overriden Methods
- (RSMutableURLRequest *) createRequest
{
    RSMutableURLRequest *request = [super createRequest];
    
    // Determine the URL
    NSString *url = [NSString stringWithFormat:@"%@/v1/%@/%@/notes?par_hash=%@", apiURL, networkID, group, self.paragraph.par_hash];
    
    if (before) 
    {
        // The before parameter expects the number to be in microseconds (seconds * 1000).
        url = [url stringByAppendingFormat:@"&before=%.0f",[before timeIntervalSince1970]*1000];
    }
    
    [request setURL:[NSURL URLWithString:url]];
    
    return request;
}

- (BOOL) handleResponse:(id)json error:(NSError *__autoreleasing *)error
{
    [super handleResponse:json error:error];
    
    // ResponseJSON should be an NSArray
    if (![json isKindOfClass:[NSArray class]])
    {
        *error = [NSError errorWithDomain:@"Invalid response from server." code:0 userInfo:nil];
        return NO;
    }
    
    // Create notes
    NSArray *notes = (NSArray *)json;
    
    // First, update user data
    [RSUserHandler updateOrCreateUsersWithArray:notes];
    
    // Then update the note data
    [RSNoteHandler updateOrCreateNotesWithArray:notes forParagraph:self.paragraph];
    
    // Request an update for the note count
    [RSNoteCountRequest retrieveNoteCountOnParagraph:self.paragraph];
    
    return YES;
}

@end

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
@synthesize paragraph=_paragraph;

+ (RSParagraphNotesRequest *) notesForParagraph: (RSParagraph *)paragraph withDelegate: (id<RSAPIRequestDelegate>)delegate
{
    RSParagraphNotesRequest *request = [[RSParagraphNotesRequest alloc] initWithParagraph:paragraph];
    request.delegate = delegate;
    [request start];
    return request;
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
- (NSMutableURLRequest *) createRequest
{
    NSMutableURLRequest *request = [super createRequest];
    
    // Determine the URL
    NSString *url = [NSString stringWithFormat:@"%@/v1/%@/%@/notes?par_hash=%@", ReadSocialAPIURL, networkID, group, self.paragraph.par_hash];
    
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
    [RSNoteHandler updateOrCreateNotesWithArray:notes];
    
    // Request an update for the note count
    [RSNoteCountRequest retrieveNoteCountOnParagraph:self.paragraph];
    
    return YES;
}

@end

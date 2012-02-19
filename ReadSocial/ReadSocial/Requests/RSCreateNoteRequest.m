//
//  RSCreateNoteRequest.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/29/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSCreateNoteRequest.h"
#import "RSParagraph+Core.h"
#import "JSONKit.h"
#import "RSNote+Core.h"

@implementation RSCreateNoteRequest
@synthesize paragraph=_paragraph, note;

+ (id) createNoteWithString: (NSString *)content forParagarph: (RSParagraph *)paragraph
{
    return [RSCreateNoteRequest createNoteWithString:content forParagraph:paragraph withDelegate:nil];
}

+ (id) createNoteWithString: (NSString *)content forParagraph: (RSParagraph *)paragraph withDelegate: (id<RSAPIRequestDelegate>)delegate
{
    RSCreateNoteRequest *request = [[RSCreateNoteRequest alloc] initWithString:content andParagraph:paragraph];
    request.delegate = delegate;
    [request start];
    return request;
}

- (id) initWithString: (NSString *)body andParagraph: (RSParagraph *)paragraph
{
    self = [super init];
    if (self)
    {
        noteBody = body;
        _paragraph = paragraph;
    }
    return self;
}

# pragma mark - RSAPIRequest Overriden Methods
- (NSMutableURLRequest *) createRequest
{
    NSMutableURLRequest *request = [super createRequest];
    
    // Set the URL
    NSString *url = [NSString stringWithFormat:@"%@/v1/%@/%@/notes/create", ReadSocialAPIURL, networkID, group];
    [request setURL:[NSURL URLWithString:url]];
    
    // Set the headers
    NSDictionary *payload = [NSDictionary dictionaryWithObjectsAndKeys:
                             networkID,                 @"net_id",
                             group,                     @"group_name",
                             noteBody,                  @"note_body",
                             self.paragraph.par_hash,   @"par_hash", 
                             nil];
    
    [request setHTTPBody:[payload JSONData]];
    
    // This is a POST request
    [request setHTTPMethod:@"POST"];
    
    return request;
}

- (BOOL) handleResponse:(id)json error:(NSError *__autoreleasing *)error
{
    [super handleResponse:json error:error];
    
    // Create a new note
    note = [RSNote noteFromDictionary:json];
    
    // Update the note count for the paragraph
    _paragraph.noteCount = [NSNumber numberWithInt:[_paragraph.notes count]];
    
    return YES;
}

@end

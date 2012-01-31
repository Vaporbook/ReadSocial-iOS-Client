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
    NSString *url = [NSString stringWithFormat:@"%@/v1/%d/%@/notes/create", ReadSocialAPIURL, networkID, group];
    [request setURL:[NSURL URLWithString:url]];
    
    // Set the headers
    NSDictionary *payload = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithInt:networkID], @"net_id",
                             group,                              @"group_name",
                             noteBody,                           @"note_body",
                             self.paragraph.par_hash,            @"par_hash", 
                             nil];
    
    [request setHTTPBody:[payload JSONData]];
    
    // This is a POST request
    [request setHTTPMethod:@"POST"];
    
    return request;
}

- (void) handleResponse:(id)json error:(NSError *__autoreleasing *)error
{
    [super handleResponse:json error:error];
    
    // Create a new note
    note = [RSNote noteFromDictionary:json];
}

@end

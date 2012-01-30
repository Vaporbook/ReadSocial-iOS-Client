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

- (NSMutableURLRequest *) createRequest
{
    NSMutableURLRequest *request = [super createRequest];
    
    // Set the URL
    NSString *url = [NSString stringWithFormat:@"%@/v1/%d/%@/notes/create", kAPIURL, networkId, defaultGroup];
    [request setURL:[NSURL URLWithString:url]];
    
    // Set the headers
    NSDictionary *payload = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithInt:networkId], @"net_id",
                             defaultGroup,                       @"group_name",
                             noteBody,                           @"note_body",
                             _paragraph.par_hash,                @"par_hash", 
                             nil];
    
    [request setHTTPBody:[payload JSONData]];
    
    // This is a POST request
    [request setHTTPMethod:@"POST"];
    
    return request;
}

- (void) responseReceived
{
    NSLog(@"Response: %@", responseJSON);
    
    // Create a new note
    RSNote *note = [RSNote noteFromDictionary:responseJSON];
    
    if ([self.delegate respondsToSelector:@selector(requestDidSucceed:)])
    {
        [self.delegate requestDidSucceed:note];
    }
}

@end

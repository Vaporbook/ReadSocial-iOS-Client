//
//  RSCreateNoteResponseRequest.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/24/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSCreateNoteResponseRequest.h"
#import "ReadSocial.h"
#import "RSNote+Core.h"
#import "RSResponse+Core.h"
#import "JSONKit.h"

@implementation RSCreateNoteResponseRequest
@synthesize note=_note, rsResponse;

+ (id) createResponse:(NSString *)content forNote:(RSNote*)note withDelegate: (id<RSAPIRequestDelegate>)delegate
{
    RSCreateNoteResponseRequest *request = [[RSCreateNoteResponseRequest alloc] initWithBody:content andNote:note];
    request.delegate = delegate;
    [request start];
    return request;
}

+ (id) createResponse:(NSString *)content forNote:(RSNote*)note
{
    return [RSCreateNoteResponseRequest createResponse:content forNote:note withDelegate:nil];
}

- (id) initWithBody:(NSString *)content andNote:(RSNote *)note
{
    self = [super init];
    noteResponseBody = content;
    _note = note;
    return self;
}

# pragma mark - RSAPIRequest Overriden Methods
- (RSMutableURLRequest *) createRequest
{
    RSMutableURLRequest *request = [super createRequest];
    
    // Set the URL
    NSString *url = [NSString stringWithFormat:@"%@/v1/%@/notes/%@/responses/create", apiURL, networkID, self.note.id];
    [request setURL:[NSURL URLWithString:url]];
    
    // Set the headers
    NSDictionary *payload = [NSDictionary dictionaryWithObjectsAndKeys:
                             networkID,         @"net_id",
                             self.note.id,      @"note_id",
                             noteResponseBody,  @"resp_body", 
                             nil];
    
    [request setHTTPBody:[payload JSONData]];
    
    // This is a POST request
    [request setHTTPMethod:@"POST"];
    
    return request;
}

- (BOOL) handleResponse:(id)json error:(NSError *__autoreleasing *)error
{
    // Create a new response
    rsResponse = [RSResponse responseFromDictionary:json];
    
    // Update the response count for the note
    self.note.responseCount = [NSNumber numberWithInt:[self.note.responseCount intValue]+1];
    
    // Trigger delegate/notification
    [[ReadSocial sharedInstance] userDidComposeResponse:rsResponse];
    
    return YES;
}

@end

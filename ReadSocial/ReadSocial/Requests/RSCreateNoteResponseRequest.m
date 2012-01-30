//
//  RSCreateNoteResponseRequest.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/24/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSCreateNoteResponseRequest.h"
#import "RSNote+Core.h"
#import "JSONKit.h"
#import "RSResponse+Core.h"

@implementation RSCreateNoteResponseRequest

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

- (NSMutableURLRequest *) createRequest
{
    NSMutableURLRequest *request = [super createRequest];
    
    // Set the URL
    NSString *url = [NSString stringWithFormat:@"%@/v1/%d/notes/%@/responses/create", kAPIURL, networkId, _note.id];
    [request setURL:[NSURL URLWithString:url]];
    
    // Set the headers
    NSDictionary *payload = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithInt:networkId],  @"net_id",
                             _note.id,                            @"note_id",
                             noteResponseBody,                    @"resp_body", 
                             nil];
    
    [request setHTTPBody:[payload JSONData]];
    
    // This is a POST request
    [request setHTTPMethod:@"POST"];
    
    return request;
}

- (void) responseReceived
{
    NSLog(@"Response: %@", responseJSON);
    
    // Create a new response
    RSResponse *response = [RSResponse responseFromDictionary:responseJSON];
    
    if ([self.delegate respondsToSelector:@selector(requestDidSucceed:)])
    {
        [self.delegate requestDidSucceed:response];
    }
}

@end

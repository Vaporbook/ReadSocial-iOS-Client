//
//  CreateNoteResponseRequest.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/24/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "CreateNoteResponseRequest.h"
#import "RSNote+Core.h"
#import "JSONKit.h"

@implementation CreateNoteResponseRequest

+ (id) createResponse:(NSString *)content forNote:(RSNote*)note
{
    CreateNoteResponseRequest *request = [[CreateNoteResponseRequest alloc] initWithBody:content andNote:note];
    [request start];
    return request;
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
    //[request addValue:noteResponseBody forHTTPHeaderField:@"resp_body"];
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSDictionary *payload = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithDouble:now*1000], @"crstamp",
                             noteResponseBody, @"resp_body", 
                             _note.id, @"note_id",
                             nil];
    
    [request setHTTPBody:[payload JSONData]];
    
    // This is a POST request
    [request setHTTPMethod:@"POST"];
    
    return request;
}

- (void) responseReceived
{
    NSLog(@"Response: %@", responseJSON);
}

@end

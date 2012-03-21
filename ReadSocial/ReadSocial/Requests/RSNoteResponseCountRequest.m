//
//  RSNoteResponseCountRequest.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 3/9/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSNoteResponseCountRequest.h"
#import "RSNote+Core.h"

@implementation RSNoteResponseCountRequest
@synthesize note, responseCount;

+ (RSNoteResponseCountRequest *) retrieveNoteResponseCountOnNote:(RSNote *)note
{
    return [RSNoteResponseCountRequest retrieveNoteResponseCountOnNote:note withDelegate:nil];
}

+ (RSNoteResponseCountRequest *) retrieveNoteResponseCountOnNote:(RSNote *)note withDelegate:(id<RSAPIRequestDelegate>) delegate
{
    RSNoteResponseCountRequest *request = [RSNoteResponseCountRequest new];
    request.note = note;
    request.delegate = delegate;
    [request start];
    return request;
}

# pragma mark - RSAPIRequest Overriden Methods
- (RSMutableURLRequest *) createRequest
{
    RSMutableURLRequest *request = [super createRequest];
    
    // Determine the URL
    NSString *url = [NSString stringWithFormat:@"%@/v1/%@/notes/%@/responses/count", RSAPIURL, networkID, self.note.id];
    
    [request setURL:[NSURL URLWithString:url]];
    
    return request;
}

- (BOOL) handleResponse:(id)json error:(NSError *__autoreleasing *)error
{
    [super handleResponse:json error:error];
    
    responseCount = [json valueForKey:@"count"];
    
    // Only update the data context if the number has changed.
    if (responseCount!=note.responseCount) 
    {
        note.responseCount = responseCount;
        return YES;
    }
    
    return NO;
}

@end

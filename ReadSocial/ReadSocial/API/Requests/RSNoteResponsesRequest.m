//
//  RSNoteResponsesRequest.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/24/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSNoteResponsesRequest.h"
#import "RSNote+Core.h"
#import "RSResponseHandler.h"
#import "RSUserHandler.h"
#import "RSNoteResponseCountRequest.h"

@implementation RSNoteResponsesRequest
@synthesize note=_note, before;

+ (RSNoteResponsesRequest *) responsesForNote: (RSNote *)note withDelegate: (id<RSAPIRequestDelegate>)delegate
{
    return [RSNoteResponsesRequest responsesForNote:note before:nil withDelegate:delegate];
}

+ (RSNoteResponsesRequest *) responsesForNote: (RSNote *)note before:(NSDate *)before withDelegate: (id<RSAPIRequestDelegate>)delegate
{
    RSNoteResponsesRequest *request = [[RSNoteResponsesRequest alloc] initWithNote:note];
    request.delegate = delegate;
    request.before = before;
    [request start];
    return request;
}

+ (RSNoteResponsesRequest *) responsesForNote: (RSNote *)note
{
    return [RSNoteResponsesRequest responsesForNote:note withDelegate:nil];
}

- (RSNoteResponsesRequest *) initWithNote: (RSNote *)note
{
    self = [super init];
    if (self)
    {
        _note = note;
    }
    return self;
}

# pragma mark - RSAPIRequest Overriden Methods
- (RSMutableURLRequest *) createRequest
{
    RSMutableURLRequest *request = [super createRequest];
    
    // Determine the URL
    NSString *url = [NSString stringWithFormat:@"%@/v1/%@/notes/%@/responses", RSAPIURL, networkID, self.note.id];
    
    // Append the before parameter if before has been specified
    if (before)
    {
        // The before parameter expects the value in microseconds (seconds * 1000)
        url = [url stringByAppendingFormat:@"?before=%.0f", [before timeIntervalSince1970] * 1000];
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
    
    // Create responses
    NSArray *responses = (NSArray *)json;
    
    [RSUserHandler updateOrCreateUsersWithArray:responses];
    [RSResponseHandler updateOrCreateResponsesWithArray:responses forNote:self.note];
    
    // Retrieve an updated number of responses on this note
    [RSNoteResponseCountRequest retrieveNoteResponseCountOnNote:self.note];
    
    // Retrieve an updated number of responses on this note
    [RSNoteResponseCountRequest retrieveNoteResponseCountOnNote:self.note];
    
    return YES;
}

@end

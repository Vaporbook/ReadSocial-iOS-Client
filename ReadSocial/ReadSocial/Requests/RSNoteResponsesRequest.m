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

@implementation RSNoteResponsesRequest
@synthesize note=_note;

+ (RSNoteResponsesRequest *) responsesForNote: (RSNote *)note withDelegate: (id<RSAPIRequestDelegate>)delegate
{
    RSNoteResponsesRequest *request = [[RSNoteResponsesRequest alloc] initWithNote:note];
    request.delegate = delegate;
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
- (NSMutableURLRequest *) createRequest
{
    NSMutableURLRequest *request = [super createRequest];
    
    // Determine the URL
    NSString *url = [NSString stringWithFormat:@"%@/v1/%d/notes/%@/responses", ReadSocialAPIURL, networkID, self.note.id];
    
    [request setURL:[NSURL URLWithString:url]];
    
    return request;
}

- (void) handleResponse:(id)json error:(NSError *__autoreleasing *)error
{
    [super handleResponse:json error:error];
    
    // ResponseJSON should be an NSArray
    if (![json isKindOfClass:[NSArray class]])
    {
        *error = [NSError errorWithDomain:@"Invalid response from server." code:0 userInfo:nil];
        return;
    }
    
    // Create responses
    NSArray *responses = (NSArray *)json;
    
    [RSUserHandler updateOrCreateUsersWithArray:responses];
    [RSResponseHandler updateOrCreateResponsesWithArray:responses];
}

@end

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

+ (id) responsesForNote: (RSNote *)note
{
    RSNoteResponsesRequest *request = [[RSNoteResponsesRequest alloc] initWithNote:note];
    [request start];
    return request;
}

- (id) initWithNote: (RSNote *)note
{
    self = [super init];
    _note = note;
    return self;
}

- (NSMutableURLRequest *) createRequest
{
    NSMutableURLRequest *request = [super createRequest];
    
    // Determine the URL
    NSString *url = [NSString stringWithFormat:@"%@/v1/%d/notes/%@/responses", kAPIURL, networkId, _note.id];
    
    [request setURL:[NSURL URLWithString:url]];
    
    return request;
}

- (void) responseReceived
{
    [super responseReceived];
    
    // ResponseJSON should be an NSArray
    if (![responseJSON isKindOfClass:[NSArray class]])
    {
        [NSException raise:@"Invalid Response" format:@"Invalid response received from API; expecting an array.\n%@", responseJSON];
    }
    
    // Create responses
    NSArray *responses = (NSArray *)responseJSON;
    
    [RSUserHandler updateOrCreateUsersWithArray:responses];
    [RSResponseHandler updateOrCreateResponsesWithArray:responses];
}

@end

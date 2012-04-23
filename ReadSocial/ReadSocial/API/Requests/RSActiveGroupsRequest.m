//
//  RSActiveGroupsRequest.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 3/14/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSActiveGroupsRequest.h"
#import "RSParagraph+Core.h"

@implementation RSActiveGroupsRequest
@synthesize paragraph=_paragraph, groups;

+ (RSActiveGroupsRequest *) requestActiveGroupsForParagraph:(RSParagraph *)paragraph withDelegate:(id)delegate
{
    RSActiveGroupsRequest *request = [[RSActiveGroupsRequest alloc] initWithParagraph:paragraph];
    request.delegate = delegate;
    [request start];
    return request;
}

- (RSActiveGroupsRequest *) initWithParagraph:(RSParagraph *)paragraph
{
    self = [super init];
    if (self)
    {
        self.paragraph = paragraph;
    }
    return self;
}

- (RSMutableURLRequest *) createRequest
{
    RSMutableURLRequest *request = [super createRequest];
    
    // Determine the URL for the request
    NSString *url = [NSString stringWithFormat:@"%@/v1/%@/groups", apiURL, networkID];
    
    // Add the paragraph argument
    if (self.paragraph)
    {
        url = [url stringByAppendingFormat:@"?par_hash=%@",self.paragraph.par_hash];
    }
    
    request.URL = [NSURL URLWithString:url];
    
    return request;
}

- (BOOL) handleResponse:(id)data error:(NSError *__autoreleasing *)error
{
    [super handleResponse:data error:error];
    
    if ([data isKindOfClass:[NSArray class]])
    {
        groups = data;
    }
    
    return NO;
}

@end

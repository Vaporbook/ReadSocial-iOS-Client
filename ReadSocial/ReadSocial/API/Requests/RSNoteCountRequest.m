//
//  RSNoteCountRequest.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/30/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSNoteCountRequest.h"
#import "RSParagraph+Core.h"

@implementation RSNoteCountRequest
@synthesize paragraph=_paragraph, noteCount;

+ (RSNoteCountRequest *) retrieveNoteCountOnParagraph: (RSParagraph *) paragraph withDelegate: (id<RSAPIRequestDelegate>)delegate
{
    RSNoteCountRequest *request = [[RSNoteCountRequest alloc] initWithParagraph: paragraph];
    request.delegate = delegate;
    [request start];
    return request;
}
+ (RSNoteCountRequest *) retrieveNoteCountOnParagraph: (RSParagraph *) paragraph
{
    return [RSNoteCountRequest retrieveNoteCountOnParagraph: paragraph withDelegate:nil];
}
- (RSNoteCountRequest *) initWithParagraph: (RSParagraph *) paragraph
{
    self = [super init];
    if (self)
    {
        self.paragraph = paragraph;
    }
    return self;
}

# pragma mark - RSAPIRequest Overriden Methods
- (RSMutableURLRequest *) createRequest
{
    RSMutableURLRequest *request = [super createRequest];
    
    // Determine the URL
    NSString *url = [NSString stringWithFormat:@"%@/v1/%@/%@/notes/count?par_hash=%@", apiURL, networkID, group, self.paragraph.par_hash];
    [request setURL:[NSURL URLWithString:url]];
    
    return request;
}

- (BOOL) handleResponse:(id)json error:(NSError *__autoreleasing *)error
{
    [super handleResponse:json error:error];
    
    noteCount = [json valueForKey:@"count"];
    
    if (noteCount!=self.paragraph.noteCount)
    {
        self.paragraph.noteCount = noteCount;
        return YES;
    }
    
    return NO;
}

@end

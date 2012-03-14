//
//  RSPage.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/30/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSPage.h"
#import "RSParagraph+Core.h"
#import "RSNoteCountRequest.h"

@implementation RSPage
@synthesize paragraphs, datasource;

- (id) init
{
    self = [super init];
    if (self)
    {
        rs = [ReadSocial sharedInstance];
        activeNoteCountRequests = [NSMutableArray array];
    }
    return self;
}

- (RSPage *) initWithDataSource: (id<ReadSocialDataSource>)pDatasource
{
    self = [self init];
    if (self)
    {
        self.datasource = pDatasource;
    }
    return self;
}

- (void) createParagraphs
{
    NSInteger count = [datasource numberOfParagraphsOnPage];
    NSMutableArray *pageParagraphs = [NSMutableArray array];
    
    for (int i=0; i<count; ++i) 
    {
        [pageParagraphs addObject:[RSParagraph createParagraphInDefaultContextForString:[datasource paragraphAtIndex:i]]];
    }
    
    paragraphs = [NSArray arrayWithArray:pageParagraphs];
}

- (void) requestCommentCount
{
    if (!paragraphs)
    {
        [self createParagraphs];
    }
    
    RSNoteCountRequest *request;
    for (RSParagraph *paragraph in paragraphs) 
    {
        request = [RSNoteCountRequest retrieveNoteCountOnParagraph:paragraph withDelegate:self];
        [activeNoteCountRequests addObject:request];
    }
}

- (void) cancelNoteCountRequests
{
    // Iterates through the active connections
    // and cancels all of them
    for (RSNoteCountRequest *request in activeNoteCountRequests) 
    {
        [request cancel];
    }
}

- (RSParagraph *) selectedParagraph
{
    // Request from the data source the index of the selected paragraph
    NSInteger index = [datasource paragraphIndexAtSelection];
    
    // Make sure index is within the range of paragraphs
    if (index>=0 && index<[paragraphs count]) 
    {
        // Determine the RSParagraph associated with that index
        return [paragraphs objectAtIndex:index];
    }
    // If the index is not within bounds, then the paragraph was not found
    else
    {
        return nil;
    }
}

- (NSString *) selection
{
    return [datasource selectedText];
}

#pragma mark - RSAPIRequest Delegate methods
- (void) requestDidSucceed:(RSNoteCountRequest *)request
{
    NSInteger index = [paragraphs indexOfObject:request.paragraph];
    [rs noteCountUpdatedForParagraph:request.paragraph atIndex:index];
    [activeNoteCountRequests removeObject:request];
}
- (void) requestDidFail:(RSAPIRequest *)request withError:(NSError *)error
{
    [activeNoteCountRequests removeObject:request];
}

@end

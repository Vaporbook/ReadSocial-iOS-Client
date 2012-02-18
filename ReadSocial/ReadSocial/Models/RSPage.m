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
    
    for (RSParagraph *paragraph in paragraphs) 
    {
        [RSNoteCountRequest retrieveNoteCountOnParagraph:paragraph withDelegate:self];
    }
}

- (RSParagraph *) selectedParagraph
{
    // Request from the data source the index of the selected paragraph
    NSInteger index = [datasource paragraphIndexAtSelection];
    
    // Determine the RSParagraph associated with that index
    return [paragraphs objectAtIndex:index];
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
}

@end

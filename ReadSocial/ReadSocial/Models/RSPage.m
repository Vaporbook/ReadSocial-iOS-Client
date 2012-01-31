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

NSString* const RSParagraphUpdatedNoteCount = @"RSParagraphUpdatedNoteCount";

@implementation RSPage
@synthesize paragraphs, datasource;

- (RSPage *) initWithDataSource: (id<ReadSocialDataSource>)pDatasource
{
    self = [super init];
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

- (NSString *) selection
{
    return [datasource paragraphAtSelection];
}

#pragma mark - RSAPIRequest Delegate methods
- (void) requestDidSucceed:(RSNoteCountRequest *)request
{
    [[NSNotificationCenter defaultCenter] postNotificationName:RSParagraphUpdatedNoteCount object:request.paragraph];
}

@end

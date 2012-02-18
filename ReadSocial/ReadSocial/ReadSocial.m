//
//  ReadSocial.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/30/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "ReadSocial.h"
#import "RSPage.h"
#import "ReadSocialSession.h"
#import "ReadSocialViewController.h"
#import "RSParagraph+Core.h"

NSString* const ReadSocialUserSelectedParagraphNotification         =   @"ReadSocialUserSelectedParagraphNotification";
NSString* const ReadSocialUserWillComposeNoteNotification           =   @"ReadSocialUserWillComposeNoteNotification";
NSString* const ReadSocialUserDidComposeNoteNotification            =   @"ReadSocialUserDidComposeNoteNotification";
NSString* const ReadSocialUserWillComposeResponseNotification       =   @"ReadSocialUserWillComposeResponseNotification";
NSString* const ReadSocialUserDidComposeResponseNotification        =   @"ReadSocialUserDidComposeResponseNotification";
NSString* const ReadSocialParagraphNoteCountUpdatedNotification     =   @"ReadSocialParagraphNoteCountUpdatedNotification";
NSString* const ReadSocialUserDidChangeGroupNotification            =   @"ReadSocialUserDidChangeGroupNotification";

@implementation ReadSocial

+ (RSPage *) initView: (id<ReadSocialDataSource>)view
{
    RSPage *page = [[RSPage alloc] initWithDataSource:view];
    [page createParagraphs];
    [page requestCommentCount];
    return page;
}

+ (void) setCurrentPage: (id<ReadSocialDataSource>)view
{
    [ReadSocialSession sharedReadSocialSession].currentPage = [ReadSocial initView:view];
}

+ (void) openReadSocialForParagraph: (NSString *)content inView: (UIView *)view
{
    // Create the paragraph
    RSParagraph *paragraph = [RSParagraph createParagraphInDefaultContextForString:content];
    
    // Find the index of the paragraph on the current page
    NSInteger index = [[ReadSocialSession sharedReadSocialSession].currentPage.paragraphs indexOfObject:paragraph];
    
    NSLog(@"Index: %d", index);
    CGRect frame = [[ReadSocialSession sharedReadSocialSession].currentPage.datasource rectForParagraphAtIndex:index];
    NSLog(@"Frame: %f, %f, %f, %f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    
    ReadSocialViewController *rsvc = [[ReadSocialViewController alloc] initWithParagraph:paragraph];
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:rsvc];
    
    [popover presentPopoverFromRect:frame inView:view permittedArrowDirections:(UIPopoverArrowDirectionDown|UIPopoverArrowDirectionUp) animated:YES];
    [ReadSocialSession sharedReadSocialSession].popover = popover;
}

+ (void) openReadSocialForSelectionInView: (UIView *)view
{
    NSString *raw = [ReadSocialSession sharedReadSocialSession].currentPage.selection;
    [ReadSocial openReadSocialForParagraph:raw inView:view];
}

@end

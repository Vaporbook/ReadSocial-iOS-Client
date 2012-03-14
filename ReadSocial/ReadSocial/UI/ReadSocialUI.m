//
//  ReadSocialUI.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 2/18/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "ReadSocialUI.h"
#import "ReadSocialAPI.h"
#import "ReadSocialViewController.h"
#import "RSNoteCountViewController.h"

/**
 Reference storage for note count view controllers created for each paragraph.
 Stores a reference to them so that they don't have to continually be recreated.
 If the class receives a memory warning, it dumps out all of its references.
 */
static NSMutableDictionary *noteCountViewControllers;

@implementation ReadSocialUI

- (void) openReadSocialForParagraph:(RSParagraph *)paragraph frame:(CGRect)frame view:(UIView *)view
{
    // Open the UI
    ReadSocialViewController *rsvc = [[ReadSocialViewController alloc] initWithParagraph:paragraph];
    rsPopover = [[UIPopoverController alloc] initWithContentViewController:rsvc];
    rsPopover.delegate = self;
    
    // Present the UIPopoverController
    // Determine the orientation of the device
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    // Determine the arrow orientation
    UIPopoverArrowDirection arrowDirection = UIPopoverArrowDirectionDown;
    switch (orientation) 
    {
        case UIInterfaceOrientationLandscapeRight:
        case UIInterfaceOrientationLandscapeLeft:
            arrowDirection = frame.origin.y < 310 ? UIPopoverArrowDirectionRight : UIPopoverArrowDirectionDown;
            break;
        default:
            arrowDirection = (UIPopoverArrowDirectionDown|UIPopoverArrowDirectionUp);
            break;
    }
    
    [rsPopover presentPopoverFromRect:frame inView:view permittedArrowDirections:arrowDirection animated:YES];
}

- (RSLoginViewController *) getLoginViewControllerWithDelegate:(id<RSLoginViewControllerDelegate,UIWebViewDelegate>)delegate
{
    RSLoginViewController *loginViewController = [RSLoginViewController new];
    loginViewController.delegate = delegate;
    loginViewController.webview.delegate = delegate;
    return loginViewController;
}

+ (ReadSocialUI *) library
{
    static ReadSocialUI *sharedInstance;
    
    if (!sharedInstance) 
    {
        sharedInstance = [ReadSocialUI new];
    }
    
    return sharedInstance;
}

+ (RSNoteCountViewController *) noteCountViewControllerForParagraph: (RSParagraph *)paragraph
{
    if (!noteCountViewControllers)
    {
        noteCountViewControllers = [NSMutableDictionary dictionary];
    }
    
    // Check if a note count view controller already exists
    RSNoteCountViewController *noteCount = [noteCountViewControllers valueForKey:paragraph.par_hash];
    if (noteCount)
    {
        return noteCount;
    }
    
    // If a note count view controller does not exist yet, create a new one
    noteCount = [[RSNoteCountViewController alloc] initWithParagraph:paragraph];
    
    // Store a reference to the note count
    [noteCountViewControllers setObject:noteCount forKey:paragraph.par_hash];
    
    // Return the note count to the caller
    return noteCount;
}

+ (void) removeAllNoteCounts
{
    for (NSString *key in noteCountViewControllers) 
    {
        RSNoteCountViewController *noteCount = [noteCountViewControllers objectForKey:key];
        [noteCount.view removeFromSuperview];
    }
    
    [noteCountViewControllers removeAllObjects];
}

# pragma mark - UIPopoverViewControllerDelegate methods
- (void) popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [[ReadSocial sharedInstance] userDidUnselectParagraph];
    rsPopover.delegate = nil;
}


@end

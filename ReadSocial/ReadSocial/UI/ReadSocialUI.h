//
//  ReadSocialUI.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 2/18/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReadSocialAPI.h"
#import "RSNoteCountViewController.h"

@class RSParagraph;
@interface ReadSocialUI : NSObject <ReadSocialUILibrary, UIPopoverControllerDelegate>
{
    UIPopoverController *rsPopover;
}

+ (ReadSocialUI *) library;
+ (RSNoteCountViewController *) noteCountViewControllerForParagraph: (RSParagraph *)paragraph;
+ (void) removeAllNoteCounts;

@end

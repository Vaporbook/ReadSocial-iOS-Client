//
//  ReadSocialUI.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 2/18/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "ReadSocialUI.h"
#import "ReadSocialAPI.h"
#import "RSNoteCountViewController.h"

/**
 Reference storage for note count view controllers created for each paragraph.
 Stores a reference to them so that they don't have to continually be recreated.
 If the class receives a memory warning, it dumps out all of its references.
 */
static NSMutableDictionary *noteCountViewControllers;

@implementation ReadSocialUI

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

@end

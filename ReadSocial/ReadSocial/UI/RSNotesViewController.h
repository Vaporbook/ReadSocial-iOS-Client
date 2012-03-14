//
//  RSNotesViewController.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/28/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSComposeNoteViewController.h"
#import "RSCreateNoteRequest.h"
#import "RSGroupViewController.h"

@class RSParagraph;
@class RSComposeNoteViewController;

@interface RSNotesViewController : UITableViewController <RSNoteCompositionDelegate,RSAPIRequestDelegate, RSGroupSelectionDelegate>
{
    NSArray *notes;
    
    /**
     The view controller keeps track of the raw paragraph so that it always has a sense of the current context.
     */
    NSString *raw;
    
    // No comments image
    UIImageView *noComments;
    
    UIActivityIndicatorView *activityIndicator;
    UIButton *currentGroup;
    
    BOOL loadingNewItems;
}

@property (strong, nonatomic) RSParagraph *paragraph;

/**
 Initializes a NotesViewController with the notes from the supplied paragraph.
 
 @param paragraph The paragraph from which to grab the notes.
 @return NotesViewController
 */
- (id) initWithParagraph: (RSParagraph*)paragraph;

@end

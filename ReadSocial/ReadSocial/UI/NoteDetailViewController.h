//
//  NoteDetailViewController.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/28/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSComposeResponseViewController.h"
#import "RSCreateNoteResponseRequest.h"

@class RSNote;
@interface NoteDetailViewController : UITableViewController <RSResponseCompositionDelegate, RSAPIRequestDelegate>
{
    NSArray *responses;
    RSComposeResponseViewController *responseComposer;
}

- (id) initWithNote: (RSNote *)note;

@property (strong, nonatomic) RSNote *note;

@end

//
//  RSComposeNoteViewController.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/29/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSCreateNoteRequest.h"

enum {
    RSNoteCompositionSucceeded  =   0,
    RSNoteCompositionCancelled  =   1,
    RSNoteCompositionFailed     =   2
};

@protocol RSNoteCompositionDelegate;
@class RSNote;

@interface RSComposeNoteViewController : UIViewController <RSAPIRequestDelegate>
{
    RSParagraph *_paragraph;
    UITextView *textview;
    UIBarButtonItem *submitButton;
    UIBarButtonItem *cancelButton;
}

@property (strong, nonatomic) id<RSNoteCompositionDelegate> delegate;
@property (strong, nonatomic, readonly) RSNote *note;

- (RSComposeNoteViewController *) initWithParagraph: (RSParagraph *)paragraph;
- (void) enableSubmitButton;
- (void) disableSubmitButton;

@end

@protocol RSNoteCompositionDelegate <NSObject>

- (void) didFinishComposingNote: (RSNote *)note withResult: (NSInteger)result error: (NSError *)error;

@end
//
//  RSComposeNoteViewController.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/29/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReadSocialAPI.h"

enum {
    RSNoteCompositionSucceeded  =   0,
    RSNoteCompositionCancelled  =   1,
    RSNoteCompositionFailed     =   2
};

@protocol RSNoteCompositionDelegate;
@protocol RSNoteTypeComposer;
@class RSNote;

@interface RSComposeNoteViewController : UIViewController <RSAPIRequestDelegate, UIScrollViewDelegate>
{
    RSParagraph *_paragraph;
    UIBarButtonItem *submitButton;
    UIBarButtonItem *cancelButton;
    
    // Note types
    NSArray *composers;
    UIScrollView *composerViews;
}

/**
 The object that will be receiving notification from the composer
 when the user either creates a note or cancels the composition.
 */
@property (strong, nonatomic) id<RSNoteCompositionDelegate> delegate;

/**
 This property is only available when the user successcully posts a note to the API.
 This will contain the note data that the user posted to the API.
 */
@property (strong, nonatomic, readonly) RSNote *note;

/**
 Reference to the composer that is currently in view.
 */
@property (strong, nonatomic, readonly) id<RSNoteTypeComposer> currentComposer;

- (RSComposeNoteViewController *) initWithParagraph: (RSParagraph *)paragraph;
- (void) enableSubmitButton;
- (void) disableSubmitButton;

@end

@protocol RSNoteCompositionDelegate <NSObject>
- (void) didFinishComposingNote: (RSNote *)note withResult: (NSInteger)result error: (NSError *)error;
@end

/**
 The RSComposeNoteViewController expects to be composed of one or more implementations
 of the RSNoteTypeComposer protocol. The implementations dictate different note types and
 the user interfaces to create a note of that type.
 */
@protocol RSNoteTypeComposer <NSObject>

- (id) initWithRootComposerController: (RSComposeNoteViewController *) rootComposerController;
+ (id) composerWithRootComposerController: (RSComposeNoteViewController *)rootComposerController;

/**
 When the request is being prepared to be sent to the API, the data needs 
 to be collected from the interface and organized into an NSDictionary
 which will be merged with the request parameters before sent to the API.
 */
- (NSDictionary *) prepareRequestArguments;

@end
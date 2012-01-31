//
//  RSComposeResponseViewController.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/30/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSCreateNoteResponseRequest.h"

enum {
    RSResponseCompositionSucceeded  =   0,
    RSResponseCompositionCancelled  =   1,
    RSResponseCompositionFailed     =   2
};


@protocol RSResponseCompositionDelegate;
@class RSResponse;

@interface RSComposeResponseViewController : UIViewController <RSAPIRequestDelegate>
{
    RSNote *_note;
    UITextView *textview;
    UIBarButtonItem *submitButton;
    UIBarButtonItem *cancelButton;
}

@property (strong, nonatomic) id<RSResponseCompositionDelegate> delegate;
@property (strong, nonatomic, readonly) RSResponse *response;

- (RSComposeResponseViewController *) initWithNote: (RSNote *)note;
- (void) enableSubmitButton;
- (void) disableSubmitButton;

@end

@protocol RSResponseCompositionDelegate <NSObject>

- (void) didFinishComposingResponse: (RSResponse *)response withResult: (NSInteger)result error: (NSError *)error;

@end

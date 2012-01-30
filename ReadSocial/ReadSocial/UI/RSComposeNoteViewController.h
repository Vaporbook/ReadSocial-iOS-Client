//
//  RSComposeNoteViewController.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/29/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RSNoteCompositionDelegate;
@class RSNote;

@interface RSComposeNoteViewController : UIViewController
{
    UITextView *textview;
    UIBarButtonItem *submitButton;
    UIBarButtonItem *cancelButton;
}

@property (strong, nonatomic) id<RSNoteCompositionDelegate> delegate;

- (void) enableSubmitButton;
- (void) disableSubmitButton;

@end

@protocol RSNoteCompositionDelegate <NSObject>

- (void) didSubmitNoteWithString: (NSString *)content;
- (void) didCancelNoteComposition;

@end
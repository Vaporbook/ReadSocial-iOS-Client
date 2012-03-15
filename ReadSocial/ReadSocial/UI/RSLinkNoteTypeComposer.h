//
//  RSLinkNoteTypeComposer.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 2/20/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSComposeNoteViewController.h"

@class UIPlaceholderTextView;
@interface RSLinkNoteTypeComposer : UIViewController <RSNoteTypeComposer, UITextViewDelegate, UITextFieldDelegate>

/**
 The link the user wants to share.
 */
@property (nonatomic, strong) IBOutlet UITextField *link;

/**
 The user's description of the contents of the link.
 */
@property (nonatomic, strong) IBOutlet UIPlaceholderTextView *linkDescription;

/**
 The note composition controller.
 */
@property (nonatomic, strong) RSComposeNoteViewController *rootComposerController;

@end

//
//  RSTextNoteTypeComposer.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 2/20/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSComposeNoteViewController.h"

@interface RSTextNoteTypeComposer : UIViewController <RSNoteTypeComposer, UITextViewDelegate>
/**
 The note composition controller.
 */
@property (nonatomic, strong) RSComposeNoteViewController *rootComposerController;
@property (nonatomic, strong) IBOutlet UITextView *noteBody;

@end

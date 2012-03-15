//
//  RSImageNoteTypeComposer.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 2/20/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSComposeNoteViewController.h"

@class UIPlaceholderTextView;
@interface RSImageNoteTypeComposer : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, RSNoteTypeComposer>
{
    BOOL imageIsSet;
}

/**
 The note composition controller.
 */
@property (nonatomic, strong) RSComposeNoteViewController *rootComposerController;
@property (nonatomic, strong) IBOutlet UIButton *imagePreview;
@property (nonatomic, strong) IBOutlet UIPlaceholderTextView *description;

- (IBAction) onSelectImage:(id)sender;

@end

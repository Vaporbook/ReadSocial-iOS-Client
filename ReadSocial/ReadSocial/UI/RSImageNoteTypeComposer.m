//
//  RSImageNoteTypeComposer.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 2/20/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSImageNoteTypeComposer.h"
#import <QuartzCore/QuartzCore.h>

@implementation RSImageNoteTypeComposer
@synthesize imagePreview, description, rootComposerController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        imageIsSet = NO;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (IBAction) onSelectImage:(id)sender
{
    NSLog(@"User selected the image.");
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = YES;
    picker.delegate = self;
    picker.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    [rootComposerController.navigationController presentModalViewController:picker animated:YES];
}

#pragma mark - RSNoteTypeComposer Methods
- (id) initWithRootComposerController: (RSComposeNoteViewController *) composerController
{
    self = [super init];
    if (self)
    {
        rootComposerController = composerController;
    }
    
    return self;
}
+ (id) composerWithRootComposerController: (RSComposeNoteViewController *)rootComposerController
{
    RSImageNoteTypeComposer *composer = [[RSImageNoteTypeComposer alloc] initWithRootComposerController:rootComposerController];
    return composer;
}

- (NSDictionary *) prepareRequestArguments
{
    UIImage *image = self.imagePreview.imageView.image;
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            description.text,                                   @"note_body",
            [RSCreateNoteRequest imageURIDataWithImage:image],  @"note_img",
            nil];
}

- (BOOL) shouldEnableSubmitButton
{
    return imageIsSet;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Add a border to the note body
    description.layer.cornerRadius = 5.0f;
    imagePreview.layer.cornerRadius = 5.0f;
    imagePreview.clipsToBounds = YES;
    imagePreview.imageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - UIImagePickerController delegate methods
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [picker dismissModalViewControllerAnimated:YES];
    [imagePreview setImage:image forState:UIControlStateNormal];
    [rootComposerController.view setNeedsDisplay];
    imageIsSet = YES;
    [rootComposerController enableSubmitButton];
}

@end

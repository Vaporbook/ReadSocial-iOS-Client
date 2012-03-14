//
//  RSImageNoteTypeComposer.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 2/20/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSImageNoteTypeComposer.h"
#import "NSData+Base64.h"

@interface RSImageNoteTypeComposer ()
- (NSData *) getImageData;
- (NSString *) getImageURIData;
@end

@implementation RSImageNoteTypeComposer
@synthesize imagePreview, description, rootComposerController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    //picker.contentSizeForViewInPopover = CGSizeMake(300.0, 300.0);
    
    [rootComposerController.navigationController presentModalViewController:picker animated:YES];
}

- (NSData *) getImageData
{
    NSData *data = UIImageJPEGRepresentation(imagePreview.imageView.image, 80);
    return data;
}

- (NSString *) getImageURIData
{
    NSData *data = [self getImageData];
    return [NSString stringWithFormat:@"data:image/jpeg;base64,%@", [data base64EncodedString]];
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
    return [NSDictionary dictionaryWithObjectsAndKeys:
            description.text,           @"note_body",
            [self getImageURIData],     @"note_img",
            nil];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
}

@end

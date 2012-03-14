//
//  RSLinkNoteTypeComposer.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 2/20/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSLinkNoteTypeComposer.h"
#import <QuartzCore/QuartzCore.h>

static NSString *linkDescriptionPlaceholder = @"Tell us about the link...";

@implementation RSLinkNoteTypeComposer
@synthesize link, linkDescription, rootComposerController;

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
    RSLinkNoteTypeComposer *composer = [[RSLinkNoteTypeComposer alloc] initWithRootComposerController:rootComposerController];
    return composer;
}
- (NSDictionary *) prepareRequestArguments
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            link.text,              @"note_link",
            linkDescription.text,   @"note_body", 
            @"link",                @"mtype",
            nil];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Add a border to the link description
    linkDescription.layer.cornerRadius = 5.0f;
    
    // Set the link description to the placeholder
    linkDescription.text = linkDescriptionPlaceholder;
    linkDescription.textColor = [UIColor grayColor];
    linkDescription.delegate = self;
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

# pragma mark - UITextViewDelegate methods
- (void) textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:linkDescriptionPlaceholder])
    {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

- (void) textViewDidEndEditing:(UITextView *)textView
{
    // If the text view is empty, set it back to the placeholder text
    if ([textView.text isEqualToString:@""]) 
    {
        textView.text = linkDescriptionPlaceholder;
        textView.textColor = [UIColor grayColor];
    }
}

@end

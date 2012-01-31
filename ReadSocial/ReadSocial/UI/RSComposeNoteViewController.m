//
//  RSComposeNoteViewController.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/29/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSComposeNoteViewController.h"

@interface RSComposeNoteViewController ()

- (void) finishNoteCompositionWithResult: (NSInteger)result error:(NSError *)error;

@end

@implementation RSComposeNoteViewController
@synthesize delegate, note;

- (RSComposeNoteViewController *) initWithParagraph: (RSParagraph *)paragraph
{
    self = [super init];
    if (self)
    {
        _paragraph = paragraph;
    }
    return self;
}

- (void) enableSubmitButton
{
    submitButton.enabled = YES;
}

- (void) disableSubmitButton
{
    submitButton.enabled = NO;
}

- (void) submitNote
{
    [textview resignFirstResponder];
    [self disableSubmitButton];
    [RSCreateNoteRequest createNoteWithString:textview.text forParagraph:_paragraph withDelegate:self];
}

- (void) cancelNoteComposition
{
    [self disableSubmitButton];
    [self finishNoteCompositionWithResult:RSNoteCompositionCancelled error:nil];
}

- (void) finishNoteCompositionWithResult: (NSInteger)result error:(NSError *)error
{
    if ([delegate respondsToSelector:@selector(didFinishComposingNote:withResult:error:)])
    {
        [delegate didFinishComposingNote:self.note withResult:result error:error];
    }
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    // Create the textview
    textview = [[UITextView alloc] init];
    
    // Create the buttons
    submitButton = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStyleDone target:self action:@selector(submitNote)];
    cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNoteComposition)];
    
    // Create the view
    UIView *view = [UIView new];
    
    // Create the view hierarchy
    [view addSubview:textview];
    
    self.view = view;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    
    self.title = @"Compose Note";
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = submitButton;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Set the dimensions of the text view
    textview.frame = self.view.bounds;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Open keyboard
    [textview becomeFirstResponder];
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

#pragma mark - RSAPIRequest Delegate Methods
- (void) requestDidSucceed:(RSCreateNoteRequest *)request
{
    NSLog(@"Note created!");
    note = request.note;
    [self finishNoteCompositionWithResult:RSNoteCompositionSucceeded error:nil];
}

- (void) requestDidFail:(RSAPIRequest *)request withError:(NSError *)error
{
    NSLog(@"Note failed to create.");
    [self enableSubmitButton];
    [self finishNoteCompositionWithResult:RSNoteCompositionFailed error:error];
}

@end

//
//  RSComposeResponseViewController.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/30/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSComposeResponseViewController.h"

@interface RSComposeResponseViewController ()

- (void) finishResponseCompositionWithResult: (NSInteger)result error:(NSError *)error;

@end

@implementation RSComposeResponseViewController
@synthesize delegate, response;

- (RSComposeResponseViewController *) initWithNote: (RSNote *)note
{
    self = [super init];
    if (self)
    {
        _note = note;
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

- (void) submitResponse
{
    [textview resignFirstResponder];
    [self disableSubmitButton];
    [RSCreateNoteResponseRequest createResponse:textview.text forNote:_note withDelegate:self];
}

- (void) cancelResponseComposition
{
    [self disableSubmitButton];
    [self finishResponseCompositionWithResult:RSResponseCompositionCancelled error:nil];
}

- (void) finishResponseCompositionWithResult: (NSInteger)result error:(NSError *)error
{
    if ([delegate respondsToSelector:@selector(didFinishComposingResponse:withResult:error:)])
    {
        [delegate didFinishComposingResponse:self.response withResult:result error:error];
    } 
}

#pragma mark - View lifecycle

- (void)loadView
{
    // Create the textview
    textview = [[UITextView alloc] init];
    textview.delegate = self;
    
    // Create the buttons
    submitButton = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStyleDone target:self action:@selector(submitResponse)];
    cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelResponseComposition)];
    
    // Create the view
    UIView *view = [UIView new];
    
    // Create the view hierarchy
    [view addSubview:textview];
    
    self.view = view;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Add Response";
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = submitButton;
    
    submitButton.enabled = NO;
    
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 300.0);
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

#pragma mark - UITextView Delegate methods
- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    // Determine what the new value of the text field is going to be
    NSString *newValue = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    // Disable the submit button if there is no text in the field.
    submitButton.enabled = (BOOL)newValue.length!=0;
    
    return YES;
}

#pragma mark - RSAPIRequest Delegate Methods
- (void) requestDidSucceed:(RSCreateNoteResponseRequest *)request
{
    NSLog(@"Response created!");
    response = request.rsResponse;
    [self finishResponseCompositionWithResult:RSResponseCompositionSucceeded error:nil];
}

- (void) requestDidFail:(RSAPIRequest *)request withError:(NSError *)error
{
    NSLog(@"Response failed to create.");
    [self enableSubmitButton];
    [self finishResponseCompositionWithResult:RSResponseCompositionFailed error:error];
}

@end

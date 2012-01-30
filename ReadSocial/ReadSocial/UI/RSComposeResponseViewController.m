//
//  RSComposeResponseViewController.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/30/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSComposeResponseViewController.h"

@implementation RSComposeResponseViewController
@synthesize delegate;

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
    
    if ([delegate respondsToSelector:@selector(didSubmitResponseWithString:)])
    {
        [delegate didSubmitResponseWithString:textview.text];
    }
}

- (void) didCancelResponseComposition
{
    if ([delegate respondsToSelector:@selector(didCancelResponseComposition)])
    {
        [delegate didCancelResponseComposition];
    }
}

#pragma mark - View lifecycle

- (void)loadView
{
    // Create the textview
    textview = [[UITextView alloc] init];
    
    // Create the buttons
    submitButton = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStyleDone target:self action:@selector(submitResponse)];
    cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(didCancelResponseComposition)];
    
    // Create the view
    UIView *view = [UIView new];
    
    // Create the view hierarchy
    [view addSubview:textview];
    
    self.view = view;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Compose Response";
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

@end

//
//  RSComposeNoteViewController.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/29/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSComposeNoteViewController.h"

#import "RSTextNoteTypeComposer.h"
#import "RSLinkNoteTypeComposer.h"
#import "RSImageNoteTypeComposer.h"

@interface RSComposeNoteViewController ()

- (void) finishNoteCompositionWithResult: (NSInteger)result error:(NSError *)error;

@end

@implementation RSComposeNoteViewController
@synthesize delegate, note, currentComposer;

- (RSComposeNoteViewController *) initWithParagraph: (RSParagraph *)paragraph
{
    self = [super init];
    if (self)
    {
        _paragraph = paragraph;
        
        // Create the array of composers
        composers = [NSArray arrayWithObjects:
                     [RSTextNoteTypeComposer new],
                     [RSLinkNoteTypeComposer new],
                     [RSImageNoteTypeComposer composerWithRootComposerController:self],
                     nil];
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
    // Get the data from the current composer
    NSDictionary *args = [currentComposer prepareRequestArguments];
    [self.view endEditing:YES];
    [self disableSubmitButton];
    
    [RSCreateNoteRequest createNoteWithArguments:args forParagraph:_paragraph withDelegate:self];
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
    // Create the buttons
    submitButton = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStyleDone target:self action:@selector(submitNote)];
    cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNoteComposition)];
    
    // Create the view
    UIView *view = [UIView new];
    
    composerViews = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 300, 250)];
    
    for (id<RSNoteTypeComposer> composer in composers) 
    {
        [composerViews addSubview:((UIViewController*)composer).view];
    }
    
    [view addSubview:composerViews];
    
    self.view = view;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Prepare the composers view
    // The scroll view that contains each composer is 250px high 
    // and 300px wide multiplied by the number of composers
    [composerViews setContentSize:CGSizeMake(300*[composers count], 250)];
    
    // Enable paging on the composers scroll view
    composerViews.pagingEnabled = YES;
    composerViews.showsHorizontalScrollIndicator = NO;
    composerViews.delegate = self;
    
    // Position each composer
    for (int i=0; i<[composers count]; ++i) 
    {
        ((UIViewController *)[composers objectAtIndex:i]).view.center = CGPointMake(300*i+150,125);
    }
    
    // Set the current composer to the first item in composers
    currentComposer = [composers objectAtIndex:0];
    
    self.title = @"Compose Note";
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = submitButton;
    
    self.contentSizeForViewInPopover = CGSizeMake(300.0, 300.0);
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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

#pragma mark - UIScrollView Delegate Methods
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Get the current scroll position (only interested in the x value)
    int xPos = (int) scrollView.contentOffset.x;
    
    // xPos should be divisible by 300 (the width of the view)
    // and whatever the product is maps to the index in composers
    // which is the currentComposer
    if (xPos % 300==0)
    {
        int index = xPos/300;
        currentComposer = [composers objectAtIndex:index];
        NSLog(@"Updated current composer!");
    }
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

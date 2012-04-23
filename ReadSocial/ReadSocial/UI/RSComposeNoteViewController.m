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
#import "RSNavigationController.h"

@interface RSComposeNoteViewController ()

- (void) finishNoteCompositionWithResult: (NSInteger)result error:(NSError *)error;
- (void) changeGroup;

@end

@implementation RSComposeNoteViewController
@synthesize delegate, note, currentComposer;

- (void) changeGroup
{
    RSGroupViewController *groupViewController = [RSGroupViewController new];
    groupViewController.delegate = self;
    groupViewController.paragraph = _paragraph;
    
    [self.navigationController presentModalViewController:[RSNavigationController wrapViewController:groupViewController withInputEnabled:NO] animated:YES];
}

- (RSComposeNoteViewController *) initWithParagraph: (RSParagraph *)paragraph
{
    self = [super init];
    if (self)
    {
        _paragraph = paragraph;
        raw = paragraph.raw;
        
        // Create the array of composers
        composers = [NSArray arrayWithObjects:
                     [RSTextNoteTypeComposer composerWithRootComposerController:self],
                     [RSLinkNoteTypeComposer composerWithRootComposerController:self],
                     [RSImageNoteTypeComposer composerWithRootComposerController:self],
                     nil];
        
        UIButton *noteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [noteButton setImage:[UIImage imageNamed:@"note-btn"] forState:UIControlStateNormal];
        [noteButton setImage:[UIImage imageNamed:@"note-active-btn"] forState:UIControlStateSelected];
        noteButton.selected = YES;
        noteButton.tag = 0;
        
        UIButton *linkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [linkButton setImage:[UIImage imageNamed:@"link-btn"] forState:UIControlStateNormal];
        [linkButton setImage:[UIImage imageNamed:@"link-active-btn"] forState:UIControlStateSelected];
        linkButton.tag = 1;
        
        UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [imageButton setImage:[UIImage imageNamed:@"image-btn"] forState:UIControlStateNormal];
        [imageButton setImage:[UIImage imageNamed:@"image-active-btn"] forState:UIControlStateSelected];
        imageButton.tag = 2;
        
        // Create the array of composer buttons
        composerButtons = [NSArray arrayWithObjects:
                           noteButton,
                           linkButton,
                           imageButton,
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
    
    // Show progress bar in nav bar
    progressView.progress = 0;
    self.navigationItem.titleView = progressView;
    
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

#pragma mark - Group Selection delegate
- (void) didChangeToGroup:(NSString *)group
{
    NSLog(@"Did change group.");
    
    // Re-create the current paragraph because changing the group will have cleared out the paragraph
    _paragraph = [RSParagraph paragraphFromHash:[raw normalizeAndHash]];
    
    // Update the group name in the group selector
    [currentGroup setTitle:[NSString stringWithFormat:@"#%@",group] forState:UIControlStateNormal];
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    // Create the buttons
    submitButton = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStyleDone target:self action:@selector(submitNote)];
    cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNoteComposition)];
    [self disableSubmitButton];
    
    // Create the view
    UIView *view = [UIView new];
    
    progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    
    composerViews = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 70, 320, 220)];
    
    currentGroup = [UIButton buttonWithType:UIButtonTypeCustom];
    currentGroup.frame = CGRectMake(0, 0, 320, 30);
    [view addSubview:currentGroup];
    
    for (id<RSNoteTypeComposer> composer in composers) 
    {
        [composerViews addSubview:((UIViewController*)composer).view];
    }
    
    for (UIButton *button in composerButtons) 
    {
        [view addSubview:button];
    }
    
    [view addSubview:composerViews];
    
    self.view = view;
}

- (void) handleComposerButton: (UIButton *)sender
{
    [composerViews scrollRectToVisible:CGRectMake(320*sender.tag, 0, 320, 220) animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    
    self.view.backgroundColor = [UIColor grayColor];
    
    // Prepare the group button
    currentGroup.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"group-background"]];
    currentGroup.titleLabel.textColor = [UIColor whiteColor];
    currentGroup.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    currentGroup.titleLabel.textAlignment = UITextAlignmentCenter;
    currentGroup.showsTouchWhenHighlighted = YES;
    [currentGroup setTitle:[NSString stringWithFormat:@"#%@", [ReadSocial currentGroup]] forState:UIControlStateNormal];
    [currentGroup addTarget:self action:@selector(changeGroup) forControlEvents:UIControlEventTouchUpInside];
    
    // Prepare the composers view
    // The scroll view that contains each composer is 200px high 
    // and 300px wide multiplied by the number of composers
    [composerViews setContentSize:CGSizeMake(320*[composers count], 220)];
    
    // Enable paging on the composers scroll view
    composerViews.pagingEnabled = YES;
    composerViews.showsHorizontalScrollIndicator = NO;
    composerViews.delegate = self;
    
    // Position each composer and it's button
    UIButton *composerButton;
    for (int i=0; i<[composers count]; ++i) 
    {
        ((UIViewController *)[composers objectAtIndex:i]).view.center = CGPointMake(320*i+160,110);
        
        composerButton = [composerButtons objectAtIndex:i];
        composerButton.showsTouchWhenHighlighted = YES;
        [composerButton addTarget:self action:@selector(handleComposerButton:) forControlEvents:UIControlEventTouchUpInside];
        composerButton.frame = CGRectMake(0, 0, 44, 44);
        composerButton.center = CGPointMake(40 + i*110, 55);
    }
    
    // Set the current composer to the first item in composers
    currentComposer = [composers objectAtIndex:0];
    
    self.title = @"Compose Note";
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = submitButton;
    
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 300.0);
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
    if (xPos % 320==0)
    {
        int index = xPos/320;
        currentComposer = [composers objectAtIndex:index];
        submitButton.enabled = [currentComposer shouldEnableSubmitButton];
        
        for (int i=0; i<[composerButtons count]; ++i) 
        {
            if (i==index) 
            {
                [[composerButtons objectAtIndex:i] setSelected:YES];
            }
            else
            {
                [[composerButtons objectAtIndex:i] setSelected:NO];
            }
        }
    }
}

#pragma mark - RSAPIRequest Delegate Methods
- (void) requestDidSucceed:(RSCreateNoteRequest *)request
{
    NSLog(@"Note created!");
    note = request.note;
    [self finishNoteCompositionWithResult:RSNoteCompositionSucceeded error:nil];
    self.navigationItem.titleView = nil;
}

- (void) requestDidFail:(RSAPIRequest *)request withError:(NSError *)error
{
    NSLog(@"Note failed to create.");
    
    // Show an alert
    [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    
    [self enableSubmitButton];
    [self finishNoteCompositionWithResult:RSNoteCompositionFailed error:error];
    self.navigationItem.titleView = nil;
}
- (void) requestMadeProgress:(NSNumber *)percentComplete
{
    [progressView setProgress:[percentComplete floatValue] animated:YES];
}

@end

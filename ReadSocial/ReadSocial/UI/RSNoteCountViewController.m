//
//  RSNoteCountViewController.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 2/18/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSNoteCountViewController.h"
#import "ReadSocialAPI.h"

@implementation RSNoteCountViewController
@synthesize paragraph, popoverParent;

- (RSNoteCountViewController *) initWithParagraph: (RSParagraph *)theParagraph
{
    self = [super init];
    if (self)
    {
        self.paragraph = theParagraph;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) onTouchedNoteCount
{
    NSLog(@"User touched note count.");
    [ReadSocial openReadSocialForParagraph:paragraph inView:popoverParent];
}

- (void) onDataChanged
{
    noteCountLabel.text = [NSString stringWithFormat:@"%@", paragraph.noteCount];
    if ([paragraph.noteCount intValue]==0)
    {
        self.view.hidden = YES;
    }
    else
    {
        self.view.hidden = NO;
    }
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    noteCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 25, 20)];
    
    // View hierarchy
    [view addSubview:noteCountLabel];
    
    // Automatically fill the height and width of the view
    noteCountLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    self.view = view;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"notes.png"]];
    
    // Label
    noteCountLabel.backgroundColor = [UIColor clearColor];
    noteCountLabel.textColor = [UIColor whiteColor];
    noteCountLabel.textAlignment = UITextAlignmentCenter;
    noteCountLabel.font = [UIFont boldSystemFontOfSize:14];
    
    if ([paragraph.noteCount intValue]==0)
    {
        self.view.hidden = YES;
    }
    
    // Prepare a tap recognizer
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTouchedNoteCount)];
    [self.view addGestureRecognizer:singleTap];
    
    // Listen for the data to change on the ReadSocial data context
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDataChanged) name:NSManagedObjectContextDidSaveNotification object:[ReadSocial dataContext]];
}


// Modify the layout
- (void) viewDidLayoutSubviews
{
    
}

- (void) viewWillAppear:(BOOL)animated
{
    if (paragraph) 
    {
        noteCountLabel.text = [NSString stringWithFormat:@"%@", paragraph.noteCount];
    }
    
    [super viewWillAppear:animated];
}

- (void) viewDidAppear:(BOOL)animated
{
    // popoverParent is required as when the user taps the note count
    // The RS API needs to be presented in a view.
    // If the implementing app hasn't specified a popoverparent
    // Then it will default to it's superview.
    if (!popoverParent)
    {
        popoverParent = self.view.superview;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    noteCountLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end

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
@synthesize paragraph;

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
    [ReadSocial openReadSocialForParagraph:paragraph inView:self.view.superview];
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    noteCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    
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
    
    self.view.backgroundColor = [UIColor redColor];
    noteCountLabel.backgroundColor = [UIColor clearColor];
    noteCountLabel.textColor = [UIColor whiteColor];
    
    // Prepare a tap recognizer
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTouchedNoteCount)];
    [self.view addGestureRecognizer:singleTap];
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

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    noteCountLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end

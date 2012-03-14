//
//  ViewController.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/24/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "ViewController.h"
#import "ReadSocialUI.h"

@implementation ViewController
@synthesize webview=_webview;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    noteCounts = [NSMutableDictionary dictionary];
    self.webview.delegate = self;
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"]]]];
}

- (void) openReadSocial
{
    [ReadSocial openReadSocialForSelectionInView:self.view];
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    // First remove all the note counts
    [ReadSocialUI removeAllNoteCounts];
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    // Then set the current page
    [ReadSocial setCurrentPage:self];
    
    // Add the note counts to the screen
    for (int i=0; i<[[ReadSocial currentPage].paragraphs count]; ++i) 
    {
        [self noteCountUpdatedForParagraph:[[ReadSocial currentPage].paragraphs objectAtIndex:i] atIndex:i];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    // When this view appears, add the custom menu item
    UIMenuItem *readSocial = [[UIMenuItem alloc] initWithTitle:@"ReadSocial" action:@selector(openReadSocial)];
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObject:readSocial]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}


#pragma mark - ReadSocial Delegate Methods
- (void) noteCountUpdatedForParagraph:(RSParagraph *)paragraph atIndex:(NSInteger)index
{
    NSLog(@"Note count updated for paragraph at index: %d", index);
    
    // Get the note count for this paragraph
    RSNoteCountViewController *noteCount = [ReadSocialUI noteCountViewControllerForParagraph:paragraph];
    
    // Add the note count if it doesn't already have a parent view
    if (!noteCount.view.superview)
    {
        NSLog(@"Added note count to view.");
        
        // Set the popover parent to it's own view
        noteCount.popoverParent = self.view;
        
        // Add the note count to the scroll view so that it scrolls with the content
        [self.webview.scrollView addSubview:noteCount.view];
    }
    
    // Determine where to place the note count
    // Use the origin of the paragraph's bounding box as a reference point
    CGRect paragraphBounds = [self rectForParagraphAtIndex:index];
    CGPoint center = paragraphBounds.origin;
    
    // Move the box to the right side of the screen
    center.x = MIN(paragraphBounds.origin.x + paragraphBounds.size.width + 20, self.view.bounds.size.width - noteCount.view.bounds.size.width/2);
    
    // Move the box to the correct location within the scroll view
    center.y += self.webview.scrollView.contentOffset.y + paragraphBounds.size.height/2;
    
    // Position the box
    noteCount.view.center = center;
}

- (void) userDidSelectParagraph:(RSParagraph *)paragraph atIndex: (NSInteger)index
{
    NSLog(@"User did select paragraph.");
    [self.webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"RS.highlightParagraphAtIndex(%d)", index]];
}

- (void) userDidUnselectParagraph
{
    [self.webview stringByEvaluatingJavaScriptFromString:@"RS.unhighlightParagraphs();"];
}

- (void) userDidComposeNote:(RSNote *)note
{
    NSLog(@"User just wrote a new note!");
}

- (void) userDidComposeResponse:(RSResponse *)response
{
    NSLog(@"User just wrote a new response!");
}

- (void) userDidChangeGroup:(NSString *)newGroup
{
    // Clear all the note counts
    // The implementing app is responsible for removing and adding note counts to paragraphs.
    [ReadSocialUI removeAllNoteCounts];
}

- (void) userDidLogin: (RSUser *)user
{
    NSLog(@"%@ just logged in.", user.name);
}

# pragma mark - ReadSocial Data Source
- (NSInteger) numberOfParagraphsOnPage
{
    return [[self.webview stringByEvaluatingJavaScriptFromString:@"RS.countParagraphsInView()"] intValue];
}

- (NSString *) paragraphAtIndex:(NSInteger)index
{
    return [self.webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"RS.paragraphAtIndex(%d).innerText", index]];
}

- (NSInteger) paragraphIndexAtSelection
{
    return [[self.webview stringByEvaluatingJavaScriptFromString:@"RS.indexAtSelection()"] intValue];
}

- (NSString *) selectedText
{
    return [self.webview stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"];
}

- (CGRect) rectForParagraphAtIndex:(NSInteger)index
{
    // Get comma-separated coordinates
    NSString *coordinates = [self.webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"RS.coordinatesForParagraphAtIndex(%d)", index]];
    
    // Default height and width of paragraph
    float x = 0;
    float y = 0;
    float width = 0;
    float height = 0;
    
    // Split the coordinates into components
    NSArray *components = [coordinates componentsSeparatedByString:@","];
    
    if ([components count]==4) 
    {
        x = [[components objectAtIndex:0] floatValue];
        y = [[components objectAtIndex:1] floatValue];
        width = [[components objectAtIndex:2] floatValue];
        height = [[components objectAtIndex:3] floatValue];
    }
    
    return CGRectMake(x, y, width, height);
}


#pragma mark - UIWebView delegate methods
- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([[[request URL] scheme] isEqualToString:@"rs"]) 
    {
        // Whenever the page scrolls, we treat that like a new page
        // Set new page
        [ReadSocial setCurrentPage:self];
        return NO;
    }
    return YES;
}
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    // Inject RS JavaScript
    NSString *path = [[NSBundle mainBundle] pathForResource:@"rs" ofType:@"js"];
    NSError *error;
    NSString *js = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if (error)
    {
        return;
    }
    
    [webView stringByEvaluatingJavaScriptFromString:js];
    [ReadSocial setCurrentPageAndDelegate:self];
    
    // Add the note counts to the screen
    for (int i=0; i<[[ReadSocial currentPage].paragraphs count]; ++i) 
    {
        [self noteCountUpdatedForParagraph:[[ReadSocial currentPage].paragraphs objectAtIndex:i] atIndex:i];
    }
}

@end

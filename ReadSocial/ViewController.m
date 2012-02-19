//
//  ViewController.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/24/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "ViewController.h"
#import "RSNoteCountViewController.h"

@implementation ViewController
@synthesize webview=_webview;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    noteCounts = [NSMutableArray array];
    self.webview.delegate = self;
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"]]]];
}

- (void) openReadSocial
{
    [ReadSocial openReadSocialForSelectionInView:self.view];
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
    
    // Add the note count to the paragraph
    RSNoteCountViewController *noteCount = [[RSNoteCountViewController alloc] initWithParagraph:paragraph];
    [self.webview.scrollView addSubview:noteCount.view];
    //[self.view addSubview:noteCount.view];
    
    // Determine where to position the notecount view
    CGRect paragraphBox = [self rectForParagraphAtIndex:index];
    
    noteCount.view.center = paragraphBox.origin;
    
    [noteCounts addObject:noteCount];
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
    
    // Split the coordinates into components
    NSArray *components = [coordinates componentsSeparatedByString:@","];
    
    float x = [[components objectAtIndex:0] floatValue];
    float y = [[components objectAtIndex:1] floatValue];
    float width = [[components objectAtIndex:2] floatValue];
    float height = [[components objectAtIndex:3] floatValue];
    
    return CGRectMake(x, y, width, height);
}


#pragma mark - UIWebView delegate methods
- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([[[request URL] scheme] isEqualToString:@"rs"]) 
    {
        // Whenever the page scrolls, we treat that like a new page
        // Clear out page counts
        for (RSNoteCountViewController *noteCount in noteCounts) 
        {
            [noteCount.view removeFromSuperview];
        }
        [noteCounts removeAllObjects];
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
}

@end

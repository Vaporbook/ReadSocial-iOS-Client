//
//  ViewController.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/24/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "ViewController.h"
#import "NotesViewController.h"
#import "RSParagraph+Core.h"
#import "NSString+RSParagraph.h"
#import "ReadSocialViewController.h"
#import "RSAuthentication.h"
#import "RSUser+Core.h"

@implementation ViewController
@synthesize webview=_webview;

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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.webview.delegate = self;
    
    // Load the content
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"]]]];
}

- (void) userLoggedIn: (NSNotification *)notification
{
    NSLog(@"WELCOME, %@", ((RSUser *)notification.object).name);
}

- (void)viewDidAppear:(BOOL)animated
{
    // When this view appears, add the custom menu item
    UIMenuItem *readSocial = [[UIMenuItem alloc] initWithTitle:@"ReadSocial" action:@selector(getWholeParagraph)];
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObject:readSocial]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoggedIn:) name:RSAuthenticationLoginWasSuccessful object:nil];
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

#pragma mark - ReadSocial behaviors
- (CGRect) getSelectionLocation
{
    float x = [[self.webview stringByEvaluatingJavaScriptFromString:@"window.getSelection().anchorNode.parentNode.getBoundingClientRect().left"] floatValue];
    float y = [[self.webview stringByEvaluatingJavaScriptFromString:@"window.getSelection().anchorNode.parentNode.getBoundingClientRect().top"] floatValue];
    float width = [[self.webview stringByEvaluatingJavaScriptFromString:@"window.getSelection().anchorNode.parentNode.getBoundingClientRect().right"] floatValue] - x;
    float height = [[self.webview stringByEvaluatingJavaScriptFromString:@"window.getSelection().anchorNode.parentNode.getBoundingClientRect().bottom"] floatValue] - y;
    return CGRectMake(x,y,width,height);
}

- (void) getWholeParagraph
{
    // Get the paragraph with the selected word
    NSString *raw = [self.webview stringByEvaluatingJavaScriptFromString:@"window.getSelection().anchorNode.data"];
    NSLog(@"Paragraph: %@", raw);
    
    // Select the entire paragraph
    [self.webview stringByEvaluatingJavaScriptFromString:@"window.getSelection().modify(\"extend\",\"backward\",\"paragraphboundary\");window.getSelection().modify(\"extend\",\"forward\",\"paragraphboundary\");"];
    
    // Get a rectangle that describes the paragraph's current place on the page
    CGRect paragraphLocation = [self getSelectionLocation];
    
    // Create a paragraph
    RSParagraph *paragraph = [RSParagraph createParagraphInDefaultContextForString:raw];
    NSLog(@"Paragraph hash: %@", paragraph.par_hash);
    
    ReadSocialViewController *rsvc = [[ReadSocialViewController alloc] initWithParagraph:paragraph];
    popover = [[UIPopoverController alloc] initWithContentViewController:rsvc];
    popover.delegate = self;
    
    [popover presentPopoverFromRect:paragraphLocation inView:self.view permittedArrowDirections:(UIPopoverArrowDirectionDown|UIPopoverArrowDirectionUp) animated:YES];
}

#pragma mark - UIWebView delegate methods
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    // Count the number of paragraphs in the document
    NSString *count = [webView stringByEvaluatingJavaScriptFromString:@"document.querySelectorAll(\"p\").length"];
    NSLog(@"Number of paragraphs: %@", count);
}

@end

//
//  RSLoginViewController.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/29/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSLoginViewController.h"
#import "AuthStatusRequest.h"
#import "JSONKit.h"

@implementation RSLoginViewController
@synthesize loginURL, webview, delegate;

- (id) init
{
    self = [super init];
    if (self)
    {
        self.modalPresentationStyle = UIModalPresentationFormSheet;
        webview = [[UIWebView alloc] init];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) didCancelLogin
{
    if ([delegate respondsToSelector:@selector(didCancelLogin)])
    {
        [delegate didCancelLogin];
    }
}

#pragma mark - View lifecycle
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Title on the navigation bar
    self.title = @"Login";
    
    // Cancel button
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(didCancelLogin)];
    
    [webview loadRequest:[NSURLRequest requestWithURL:loginURL]];
    [self.view addSubview:webview];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    webview.frame = self.view.bounds;
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

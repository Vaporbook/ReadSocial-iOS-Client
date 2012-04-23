//
//  RSAuthProviderLogin.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 4/23/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSAuthProviderLogin.h"
#import "ReadSocial.h"
#import "RSAuthProvider.h"

@implementation RSAuthProviderLogin
@synthesize provider;

- (id) initWithProvider: (RSAuthProvider *)theProvider andDelegate:(id<UIWebViewDelegate>)delegate
{
    self = [super init];
    if (self)
    {
        webview = [[UIWebView alloc] init];
        webview.delegate = delegate;
        self.provider = theProvider;
    }
    return self;
}

- (id<UIWebViewDelegate>) delegate
{
    return webview.delegate;
}

- (void) setDelegate:(id<UIWebViewDelegate>)delegate
{
    webview.delegate = delegate;
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.provider.name;
    
    webview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    webview.scalesPageToFit = YES;
    webview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:webview];
    
    NSString *url = [NSString stringWithFormat:@"%@/v1/%@/%@", [ReadSocial sharedInstance].apiURL, [ReadSocial networkID], provider.endpoint];
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.provider = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end

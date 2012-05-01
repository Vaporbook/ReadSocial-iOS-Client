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
@synthesize provider, delegate=_delegate;

- (id) initWithProvider: (RSAuthProvider *)theProvider andDelegate:(id<UIWebViewDelegate>)delegate
{
    self = [super init];
    if (self)
    {
        webview = [[UIWebView alloc] init];
        webview.delegate = self;
        self.provider = theProvider;
        self.delegate = delegate;
        
        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.hidesWhenStopped = YES;
    }
    return self;
}

#pragma mark - Webview Delegate methods
- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    BOOL result = YES;
    
    if ([_delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)])
    {
        result = [_delegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    
    return result;
}
- (void) webViewDidStartLoad:(UIWebView *)webView
{
    if ([_delegate respondsToSelector:@selector(webViewDidStartLoad:)])
    {
        [_delegate webViewDidStartLoad:webView];
    }
    [activityIndicator startAnimating];
}
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    if ([_delegate respondsToSelector:@selector(webViewDidFinishLoad:)])
    {
        [_delegate webViewDidFinishLoad:webView];
    }
    [activityIndicator stopAnimating];
}
- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if ([_delegate respondsToSelector:@selector(webView:didFailLoadWithError:)])
    {
        [_delegate webView:webview didFailLoadWithError:error];
    }
    [activityIndicator stopAnimating];
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.provider.name;
    
    //webview.scalesPageToFit = YES;
    webview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:webview];
    
    NSString *url = [NSString stringWithFormat:@"%@/v1/%@/%@", [ReadSocial sharedInstance].apiURL, [ReadSocial networkID], provider.endpoint];
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    
    [self.view addSubview:activityIndicator];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    webview.frame = self.view.frame;
    activityIndicator.center = self.view.center;
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

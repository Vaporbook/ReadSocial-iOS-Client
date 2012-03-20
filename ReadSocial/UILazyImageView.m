//
//  UILazyImageView.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 2/21/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "UILazyImageView.h"

@implementation UILazyImageView
@synthesize url=_url;
static NSMutableDictionary *cache;

- (id) init
{
    self = [super init];
    if (self)
    {
        receivedData = [NSMutableData data];
    }
    return self;
}

- (id)initWithURL:(NSURL *)url
{
    self = [self init];
    
    if (self)
    {
        [self loadWithURL:url];
    }
    
    return self;
}

- (void)loadWithURL:(NSURL *)url    
{
    if (!cache)
    {
        NSLog(@"Cache did not exist.");
        cache = [NSMutableDictionary dictionary];
    }
    
    if ([cache valueForKey:[url absoluteString]]) 
    {
        NSLog(@"Image was cached: %@", url);
        self.image = [UIImage imageWithData:[cache objectForKey:[url absoluteString]]];
        return;
    }
    
    NSLog(@"Downloading image: %@", url);
    [self cancelImageDownload];
    self.url = url;

    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.hidesWhenStopped = YES;
    activityIndicator.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [self addSubview:activityIndicator];
    
    receivedData = [NSMutableData data];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // Do NOT request cookies when downloading the image.
    // This is primarily for the benefit of the ReadSocial API.
    // The user's session ID is stored in a cookie and is based on his/her user agent string.
    // Because the cookie needs to be set by the webview and I can't change the user agent 
    // used by UIWebView, I have to manually set the user agent on all the API requests--
    // and this includes images--otherwise the user has to log in again. Instead of setting 
    // the user agent on every request, I will just prevent cookies from being returned from the request.
    request.HTTPShouldHandleCookies = NO;
    
    downloadingConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    [activityIndicator startAnimating];
}

- (void) setImage:(UIImage *)image
{
    [self cancelImageDownload];
    [super setImage:image];
}

- (void) cancelImageDownload
{
    if (!downloadingConnection)
    {
        return;
    }
    
    [downloadingConnection cancel];
    downloadingConnection = nil;
    [activityIndicator stopAnimating];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    downloadingConnection = nil;
    [activityIndicator stopAnimating];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [receivedData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Save the image in the cache
    [cache setObject:receivedData forKey:[self.url absoluteString]];
    
    self.alpha = 0;
    [activityIndicator stopAnimating];
    self.image = [[UIImage alloc] initWithData:receivedData];
    [UIView beginAnimations:@"fadeIn" context:NULL];
    [UIView setAnimationDuration:0.5];
    self.alpha = 1.0;
    [UIView commitAnimations];
    
    downloadingConnection = nil;
}


@end

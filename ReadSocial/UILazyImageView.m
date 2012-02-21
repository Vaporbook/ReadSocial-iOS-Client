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
    static NSMutableDictionary *cache;
    
    if (!cache)
    {
        cache = [NSMutableDictionary dictionary];
    }
    
    if ([cache valueForKey:[url absoluteString]]) 
    {
        self.image = [UIImage imageWithData:[cache objectForKey:[url absoluteString]]];
        return;
    }

    self.url = url;
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.hidesWhenStopped = YES;
    activityIndicator.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [self addSubview:activityIndicator];
    
    receivedData = [NSMutableData data];
    
    [cache setObject:receivedData forKey:[url absoluteString]];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:url] delegate:self];
    [connection start];
    [activityIndicator startAnimating];
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
    self.alpha = 0;
    [activityIndicator stopAnimating];
    self.image = [[UIImage alloc] initWithData:receivedData];
    [UIView beginAnimations:@"fadeIn" context:NULL];
    [UIView setAnimationDuration:0.5];
    self.alpha = 1.0;
    [UIView commitAnimations];
}


@end
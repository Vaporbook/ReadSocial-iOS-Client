//
//  UILazyImageView.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 2/21/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILazyImageView : UIImageView
{
    NSMutableData *receivedData;
    UIActivityIndicatorView *activityIndicator;
}

@property (nonatomic, strong) NSURL *url;

- (id) initWithURL:(NSURL *)url;
- (void) loadWithURL:(NSURL *)url;

@end

//
//  RSAuthProviderLogin.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 4/23/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RSAuthProvider;
@interface RSAuthProviderLogin : UIViewController<UIWebViewDelegate>
{
    UIWebView *webview;
    UIActivityIndicatorView *activityIndicator;
}

@property (nonatomic,strong) RSAuthProvider *provider;
@property (nonatomic,assign) id<UIWebViewDelegate> delegate;

- (id) initWithProvider: (RSAuthProvider *)theProvider andDelegate:(id<UIWebViewDelegate>)delegate;
@end
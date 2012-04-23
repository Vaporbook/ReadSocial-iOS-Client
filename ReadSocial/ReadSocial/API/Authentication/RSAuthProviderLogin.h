//
//  RSAuthProviderLogin.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 4/23/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RSAuthProvider;
@interface RSAuthProviderLogin : UIViewController
{
    UIWebView *webview;
}

@property (nonatomic,strong) RSAuthProvider *provider;
@property (nonatomic,strong) id<UIWebViewDelegate> delegate;

- (id) initWithProvider: (RSAuthProvider *)theProvider andDelegate:(id<UIWebViewDelegate>)delegate;

@end
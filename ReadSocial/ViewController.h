//
//  ViewController.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/24/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReadSocial.h"

@class RSAuthentication;
@interface ViewController : UIViewController <UIWebViewDelegate, ReadSocialDataSource>

@property (strong, nonatomic) IBOutlet UIWebView *webview;

@end

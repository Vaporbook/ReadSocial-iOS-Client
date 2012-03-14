//
//  RSLoginViewController.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/29/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReadSocialAPI.h"

@protocol RSLoginViewControllerDelegate;
@interface RSLoginViewController : UIViewController

@property (strong, nonatomic) NSURL *loginURL;
@property (strong, nonatomic) UIWebView *webview;
@property (strong, nonatomic) id<RSLoginViewControllerDelegate> delegate;

@end
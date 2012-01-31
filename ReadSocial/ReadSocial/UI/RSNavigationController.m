//
//  RSNavigationController.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/31/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSNavigationController.h"

@implementation RSNavigationController

+ (RSNavigationController *) wrapViewController: (UIViewController *)rootViewController withInputEnabled: (BOOL)inputEnabled
{
    RSNavigationController *controller = [[RSNavigationController alloc] initWithRootViewController:rootViewController andInputEnabled:inputEnabled];
    return controller;
}

- (RSNavigationController *) initWithRootViewController:(UIViewController *)rootViewController andInputEnabled: (BOOL)inputEnabled
{
    self = [self initWithRootViewController:rootViewController];
    if (self)
    {
        self.modalInPopover = inputEnabled;
    }
    return self;
}

- (id) initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self)
    {
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    return self;
}

@end

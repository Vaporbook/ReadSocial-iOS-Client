//
//  RSNavigationController.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/31/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSNavigationController : UINavigationController

+ (RSNavigationController *) wrapViewController: (UIViewController *)rootViewController withInputEnabled: (BOOL)inputEnabled;

/**
 Quickly creates a UINavigationController for wrapping modal views.
 Sets the proper parameters so that the navigation controller appears within the popover.
 
 @param rootViewController The root view controller of the UINavigationConroller.
 @param inputEnabled Set to YES to disable tapping outside the popover to close the popover (ideal for views with user input).
 @return Initialized RSNavigationController.
 */

- (RSNavigationController *) initWithRootViewController:(UIViewController *)rootViewController andInputEnabled: (BOOL)inputEnabled;

@end

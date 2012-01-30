//
//  RSComposeResponseViewController.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/30/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RSResponseCompositionDelegate;

@interface RSComposeResponseViewController : UIViewController
{
    UITextView *textview;
    UIBarButtonItem *submitButton;
    UIBarButtonItem *cancelButton;
}

@property (strong, nonatomic) id<RSResponseCompositionDelegate> delegate;

- (void) enableSubmitButton;
- (void) disableSubmitButton;

@end

@protocol RSResponseCompositionDelegate <NSObject>

- (void) didSubmitResponseWithString: (NSString *)content;
- (void) didCancelResponseComposition;

@end

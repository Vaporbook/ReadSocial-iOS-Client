//
//  RSNoteCountViewController.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 2/18/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RSParagraph;
@interface RSNoteCountViewController : UIViewController
{
    UILabel *noteCountLabel;
}

/**
 The paragraph represented by the note count.
 */
@property (nonatomic, strong) RSParagraph *paragraph;

/**
 The view to present the popover within.
 */
@property (nonatomic, strong) UIView *popoverParent;

/**
 Initialize the view controller with a reference to the paragraph it represents.
 */
- (RSNoteCountViewController *) initWithParagraph: (RSParagraph *)theParagraph;

@end

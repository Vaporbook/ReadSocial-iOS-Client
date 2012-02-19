//
//  ReadSocialUI.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 2/18/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSNoteCountViewController.h"

@class RSParagraph;
@interface ReadSocialUI : NSObject

+ (RSNoteCountViewController *) noteCountViewControllerForParagraph: (RSParagraph *)paragraph;
+ (void) removeAllNoteCounts;

@end

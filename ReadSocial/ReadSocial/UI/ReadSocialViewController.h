//
//  ReadSocialViewController.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/28/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RSParagraph;
@class NotesViewController;
@class RSAuthentication;
@interface ReadSocialViewController : UINavigationController
{
    
}

@property (strong, nonatomic) RSParagraph *paragraph;

- (id) initWithParagraph:(RSParagraph*) paragraph;

@end

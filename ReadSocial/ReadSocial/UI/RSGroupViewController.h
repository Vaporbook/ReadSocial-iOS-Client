//
//  RSGroupViewController.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/30/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReadSocialAPI.h"

@protocol RSGroupSelectionDelegate;
@interface RSGroupViewController : UITableViewController <RSAPIRequestDelegate, UITextFieldDelegate>
{
    /**
     The group the session was in when the view was created.
     */
    NSString *oldGroup;
    
    /**
     The group name selected in the interface.
     */
    NSString *selectedGroup;
    
    /**
     The user can enter a custom group in the custom group field.
     This field appears in the table header.
     */
    UITextField *customGroup;
    
    /**
     The activity indicator that appears in the upper left while it
     is request group names from the API.
     */
    UIActivityIndicatorView *activityIndicator;
}

@property (strong, nonatomic) NSArray *groups;
@property (strong, nonatomic) id<RSGroupSelectionDelegate>delegate;
@property (strong, nonatomic) RSParagraph *paragraph;

@end

@protocol RSGroupSelectionDelegate <NSObject>

- (void) didChangeToGroup: (NSString *)group;

@end
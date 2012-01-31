//
//  RSGroupViewController.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/30/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RSGroupSelectionDelegate;
@interface RSGroupViewController : UITableViewController
{
    /**
     The group the session was in when the view was created.
     */
    NSString *oldGroup;
    
    /**
     The group name selected in the interface.
     */
    NSString *selectedGroup;
}

@property (strong, nonatomic) NSArray *groups;
@property (strong, nonatomic) id<RSGroupSelectionDelegate>delegate;

@end

@protocol RSGroupSelectionDelegate <NSObject>

- (void) didChangeToGroup: (NSString *)group;

@end
//
//  RSNoteDetailViewController.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/28/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReadSocialAPI.h"
#import "RSComposeResponseViewController.h"

@class RSNote;
@interface RSNoteDetailViewController : UITableViewController <RSResponseCompositionDelegate, RSAPIRequestDelegate>
{
    NSArray *responses;
    
    int loadMoreRowIndex;
    BOOL loadMoreRowVisible;
    BOOL loadingNewData;
}

- (id) initWithNote: (RSNote *)note;

@property (strong, nonatomic) RSNote *note;

@end

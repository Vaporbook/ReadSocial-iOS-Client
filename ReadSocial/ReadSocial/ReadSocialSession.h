//
//  ReadSocialSession.h
//  ReadSocial
//
//  Tracks the user's current session inside ReadSocial.
//  Keeps track of the RSPage the user is currently on, the group the user is currently in, etc.
//
//  Created by Daniel Pfeiffer on 1/30/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RSPage;
@interface ReadSocialSession : NSObject
{
    UIMenuItem *rsMenuItem;
}

- (void) changeToGroupWithString: (NSString *)groupName;
+ (ReadSocialSession *) sharedReadSocialSession;
+ (NSString *) defaultGroup;

@property (strong, readonly) NSString *currentGroup;
@property (strong, nonatomic) RSPage *currentPage;
@property (strong, nonatomic) UIPopoverController *popover;
@property (nonatomic) int networkID;

@end

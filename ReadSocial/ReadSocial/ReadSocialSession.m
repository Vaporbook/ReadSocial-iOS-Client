//
//  ReadSocialSession.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/30/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "ReadSocialSession.h"
#import "DataContext.h"
#import "RSPage.h"

@implementation ReadSocialSession
@synthesize currentGroup=_currentGroup, currentPage, popover, networkID;

- (id) init
{
    self = [super init];
    if (self)
    {
        _currentGroup = [ReadSocialSession defaultGroup];
        rsMenuItem = [[UIMenuItem alloc] initWithTitle:@"ReadSocial" action:@selector(sayHello)];
    }
    return self;
}

+ (NSString *) defaultGroup
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSString *lastGroup = [[NSUserDefaults standardUserDefaults] valueForKey:@"ReadSocialGroup"];
    
    if (lastGroup)
    {
        return lastGroup;
    }
    else
    {
        return @"partner-testing-channel";
    }
}

- (void) changeToGroupWithString: (NSString *)groupName
{
    // Set the new group name
    _currentGroup = groupName;
    
    // Save the last used group
    [[NSUserDefaults standardUserDefaults] setValue:groupName forKey:@"ReadSocialGroup"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Clear out the persistent store
    [DataContext erase];
    
    // Update the current page
    [currentPage createParagraphs];
    [currentPage requestCommentCount];
}

+ (ReadSocialSession *) sharedReadSocialSession
{
    static ReadSocialSession *sharedSession;
    @synchronized(self)
    {
        if (!sharedSession)
        {
            sharedSession = [ReadSocialSession new];
        }
        return sharedSession;
    }
}

@end

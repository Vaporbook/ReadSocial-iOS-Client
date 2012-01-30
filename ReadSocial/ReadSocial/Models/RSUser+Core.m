//
//  RSUser+Core.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/29/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSUser+Core.h"
#import "DataContext.h"

NSString* const kUserId     =   @"uid";
NSString* const kUserName   =   @"uname";
NSString* const kUserImage  =   @"uimg";
NSString* const kUserDomain =   @"udom";

@implementation RSUser (Core)

- (UIImage *) getImage
{
    return [UIImage imageWithData: self.imageData];
}

+ (RSUser *) userWithDictionary: (NSDictionary *)args
{
    // Creates a new managed object
    RSUser *user    = (RSUser *)[NSEntityDescription insertNewObjectForEntityForName:@"RSUser" inManagedObjectContext:[DataContext defaultContext]];
    user.uid        = [NSNumber numberWithInt:[[args valueForKey:kUserId] intValue]]; // Make sure that uid is an integer
    
    [user updateUserWithDictionary:args];
    
    return user;
}

#warning This method always returns YES even if no changes were made.
- (BOOL) updateUserWithDictionary: (NSDictionary *)args
{
    self.name       =   [args valueForKey:kUserName];
    self.udom       =   [args valueForKey:kUserDomain];
    self.imageURL   =   [args valueForKey:kUserImage];
    
    // Only update the image if it is over a week old
    if (!self.updated || [[NSDate date] timeIntervalSinceDate:self.updated] > 604800) // 604800 is the number of seconds in one week
    {
        NSLog(@"Updating user image.");
        self.imageData  =   [NSData dataWithContentsOfURL:[NSURL URLWithString:[args valueForKey:kUserImage]]];
        self.updated    =   [NSDate date];
    }
    else
    {
        NSLog(@"Not updating image--using cached version.");
    }
    
    return YES;
}

@end

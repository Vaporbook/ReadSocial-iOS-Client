//
//  DataContext.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/24/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "DataContext.h"
#import "AppDelegate.h"

@implementation DataContext

+ (NSManagedObjectContext *) defaultContext
{
    return ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
}

+ (void) save
{
    [((AppDelegate *)[UIApplication sharedApplication].delegate) saveContext];
}

+ (void) erase
{
    [((AppDelegate *)[UIApplication sharedApplication].delegate) resetStore];
}

@end

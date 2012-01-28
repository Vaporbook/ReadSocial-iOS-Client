//
//  DataContext.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/24/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import <Foundation/Foundation.h>

// Simply a conveniece way at saving and retrieving the app data context
@interface DataContext : NSObject

+ (NSManagedObjectContext *) defaultContext;
+ (void) save;

@end

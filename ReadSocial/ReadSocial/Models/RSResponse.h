//
//  RSResponse.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/24/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RSNote;

@interface RSResponse : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) RSNote *note;
@property (nonatomic, retain) NSManagedObject *user;

@end

//
//  RSNote.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/24/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RSParagraph;

@interface RSNote : NSManagedObject

@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSManagedObject *group;
@property (nonatomic, retain) RSParagraph *paragraph;
@property (nonatomic, retain) NSSet *responses;
@property (nonatomic, retain) NSManagedObject *user;
@end

@interface RSNote (CoreDataGeneratedAccessors)

- (void)addResponsesObject:(NSManagedObject *)value;
- (void)removeResponsesObject:(NSManagedObject *)value;
- (void)addResponses:(NSSet *)values;
- (void)removeResponses:(NSSet *)values;
@end

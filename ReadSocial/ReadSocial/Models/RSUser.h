//
//  RSUser.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/29/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RSNote, RSResponse;

@interface RSUser : NSManagedObject

@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) NSData * imageData;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * udom;
@property (nonatomic, retain) NSDate * updated;
@property (nonatomic, retain) NSSet *notes;
@property (nonatomic, retain) NSSet *responses;
@end

@interface RSUser (CoreDataGeneratedAccessors)

- (void)addNotesObject:(RSNote *)value;
- (void)removeNotesObject:(RSNote *)value;
- (void)addNotes:(NSSet *)values;
- (void)removeNotes:(NSSet *)values;
- (void)addResponsesObject:(RSResponse *)value;
- (void)removeResponsesObject:(RSResponse *)value;
- (void)addResponses:(NSSet *)values;
- (void)removeResponses:(NSSet *)values;
@end

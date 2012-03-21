//
//  RSParagraph.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/24/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RSParagraph : NSManagedObject

@property (nonatomic, retain) NSNumber * noteCount;
@property (nonatomic, retain) NSString * raw;
@property (nonatomic, retain) NSString * par_hash;
@property (nonatomic, retain) NSSet *notes;
@end

@interface RSParagraph (CoreDataGeneratedAccessors)

- (void)addNotesObject:(NSManagedObject *)value;
- (void)removeNotesObject:(NSManagedObject *)value;
- (void)addNotes:(NSSet *)values;
- (void)removeNotes:(NSSet *)values;
@end

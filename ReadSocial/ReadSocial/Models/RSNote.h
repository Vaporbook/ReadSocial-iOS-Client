//
//  RSNote.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 2/21/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RSParagraph, RSResponse, RSUser;

@interface RSNote : NSManagedObject

@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSString * group;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * thumbnailURL;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * highlightedText;
@property (nonatomic, retain) RSParagraph *paragraph;
@property (nonatomic, retain) NSSet *responses;
@property (nonatomic, retain) RSUser *user;
@end

@interface RSNote (CoreDataGeneratedAccessors)

- (void)addResponsesObject:(RSResponse *)value;
- (void)removeResponsesObject:(RSResponse *)value;
- (void)addResponses:(NSSet *)values;
- (void)removeResponses:(NSSet *)values;
@end

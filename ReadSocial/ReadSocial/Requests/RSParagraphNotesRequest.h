//
//  RSParagraphNotesRequest.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/24/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSAPIRequest.h"

@class RSParagraph;

@interface RSParagraphNotesRequest : RSAPIRequest

@property (strong, nonatomic) RSParagraph *paragraph;
@property (strong, nonatomic) NSDate *before;

+ (RSParagraphNotesRequest *) notesForParagraph: (RSParagraph *)paragraph beforeDate:(NSDate *)before withDelegate: (id<RSAPIRequestDelegate>)delegate;
+ (RSParagraphNotesRequest *) notesForParagraph: (RSParagraph *)paragraph withDelegate: (id<RSAPIRequestDelegate>)delegate;
+ (RSParagraphNotesRequest *) notesForParagraph: (RSParagraph *)paragraph;
- (RSParagraphNotesRequest *) initWithParagraph: (RSParagraph *)paragraph;

@end

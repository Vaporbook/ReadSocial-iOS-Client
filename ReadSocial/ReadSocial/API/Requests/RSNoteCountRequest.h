//
//  RSNoteCountRequest.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/30/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSAPIRequest.h"

@class RSParagraph;
@interface RSNoteCountRequest : RSAPIRequest

/**
 The paragraph to count the notes on.
 */
@property (strong, nonatomic) RSParagraph *paragraph;

/**
 The retrieved note count for the paragraph.
 Only available after the API responds. This should be accessed through the success delegate method.
 */
@property (strong, nonatomic, readonly) NSNumber *noteCount;

+ (RSNoteCountRequest *) retrieveNoteCountOnParagraph: (RSParagraph *) paragraph withDelegate: (id<RSAPIRequestDelegate>)delegate;
+ (RSNoteCountRequest *) retrieveNoteCountOnParagraph: (RSParagraph *) paragraph;
- (RSNoteCountRequest *) initWithParagraph: (RSParagraph *) paragraph;

@end

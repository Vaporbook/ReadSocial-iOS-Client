//
//  RSNoteResponsesRequest.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/24/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSAPIRequest.h"

@class RSNote;
@interface RSNoteResponsesRequest : RSAPIRequest

/**
 Only load the responses that were made BEFORE the specified date.
 */
@property (strong, nonatomic) NSDate *before;

/**
 The note from which to load responses.
 */
@property (strong, nonatomic) RSNote *note;

+ (RSNoteResponsesRequest *) responsesForNote: (RSNote *)note before:(NSDate *)before withDelegate: (id<RSAPIRequestDelegate>)delegate;
+ (RSNoteResponsesRequest *) responsesForNote: (RSNote *)note withDelegate: (id<RSAPIRequestDelegate>)delegate;
+ (RSNoteResponsesRequest *) responsesForNote: (RSNote *)note;
- (RSNoteResponsesRequest *) initWithNote: (RSNote *)note;

@end

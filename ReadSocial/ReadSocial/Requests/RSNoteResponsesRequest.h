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

@property (strong, nonatomic) RSNote *note;

+ (RSNoteResponsesRequest *) responsesForNote: (RSNote *)note withDelegate: (id<RSAPIRequestDelegate>)delegate;
+ (RSNoteResponsesRequest *) responsesForNote: (RSNote *)note;
- (RSNoteResponsesRequest *) initWithNote: (RSNote *)note;

@end

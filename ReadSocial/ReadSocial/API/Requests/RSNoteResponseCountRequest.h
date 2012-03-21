//
//  RSNoteResponseCountRequest.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 3/9/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSAPIRequest.h"

@class RSNote;
@interface RSNoteResponseCountRequest : RSAPIRequest

/**
 The note to count responses on.
 */
@property (strong, nonatomic) RSNote *note;

/**
 The retrieved response count for the note.
 Only available after the API responds. This should be accessed through the success delegate method.
 */
@property (strong, nonatomic, readonly) NSNumber *responseCount;

+ (RSNoteResponseCountRequest *) retrieveNoteResponseCountOnNote:(RSNote *)note;
+ (RSNoteResponseCountRequest *) retrieveNoteResponseCountOnNote:(RSNote *)note withDelegate:(id<RSAPIRequestDelegate>) delegate;

@end

//
//  RSNoteResponsesRequest.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/24/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSAPIRequest.h"

@class RSNote;
@interface RSNoteResponsesRequest : RSAPIRequest {
    RSNote* _note;
}

+ (id) responsesForNote: (RSNote *)note;
- (id) initWithNote: (RSNote *)note;

@end

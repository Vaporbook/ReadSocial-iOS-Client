//
//  CreateNoteResponseRequest.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/24/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSAPIRequest.h"

@class RSNote;
@interface CreateNoteResponseRequest : RSAPIRequest {
    RSNote *_note;
    NSString *noteResponseBody;
}

+ (id) createResponse:(NSString *)content forNote:(RSNote*)note;
- (id) initWithBody:(NSString *)content andNote:(RSNote *)note;

@end

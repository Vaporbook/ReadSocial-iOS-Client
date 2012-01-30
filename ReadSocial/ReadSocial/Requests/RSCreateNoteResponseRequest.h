//
//  RSCreateNoteResponseRequest.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/24/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSAPIRequest.h"

@class RSNote;
@interface RSCreateNoteResponseRequest : RSAPIRequest {
    RSNote *_note;
    NSString *noteResponseBody;
}

+ (id) createResponse:(NSString *)content forNote:(RSNote*)note;
+ (id) createResponse:(NSString *)content forNote:(RSNote*)note withDelegate: (id<RSAPIRequestDelegate>)delegate;
- (id) initWithBody:(NSString *)content andNote:(RSNote *)note;

@end

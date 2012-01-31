//
//  RSCreateNoteResponseRequest.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/24/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSAPIRequest.h"

@class RSNote;
@class RSResponse;
@interface RSCreateNoteResponseRequest : RSAPIRequest 
{
    NSString *noteResponseBody;
}

@property (strong, nonatomic) RSNote *note;
@property (strong, nonatomic) RSResponse *rsResponse;

+ (id) createResponse:(NSString *)content forNote:(RSNote*)note;
+ (id) createResponse:(NSString *)content forNote:(RSNote*)note withDelegate: (id<RSAPIRequestDelegate>)delegate;
- (id) initWithBody:(NSString *)content andNote:(RSNote *)note;

@end

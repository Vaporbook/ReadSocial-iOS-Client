//
//  RSCreateNoteRequest.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/29/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSAPIRequest.h"

@class RSParagraph;
@class RSNote;
@interface RSCreateNoteRequest : RSAPIRequest
{
    NSString *noteBody;
}

@property (strong, nonatomic) RSParagraph *paragraph;
@property (strong, nonatomic) RSNote *note;

+ (id) createNoteWithString: (NSString *)content forParagarph: (RSParagraph *)paragraph;
+ (id) createNoteWithString: (NSString *)content forParagraph: (RSParagraph *)paragraph withDelegate: (id<RSAPIRequestDelegate>)delegate;
- (id) initWithString: (NSString *)body andParagraph: (RSParagraph *)paragraph;

@end

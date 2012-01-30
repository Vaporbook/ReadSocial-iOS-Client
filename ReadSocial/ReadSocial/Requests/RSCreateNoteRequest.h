//
//  RSCreateNoteRequest.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/29/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSAPIRequest.h"

@class RSParagraph;
@interface RSCreateNoteRequest : RSAPIRequest
{
    RSParagraph *_paragraph;
    NSString *noteBody;
}

+ (id) createNoteWithString: (NSString *)content forParagarph: (RSParagraph *)paragraph;
+ (id) createNoteWithString: (NSString *)content forParagraph: (RSParagraph *)paragraph withDelegate: (id<RSAPIRequestDelegate>)delegate;
- (id) initWithString: (NSString *)body andParagraph: (RSParagraph *)paragraph;

@end

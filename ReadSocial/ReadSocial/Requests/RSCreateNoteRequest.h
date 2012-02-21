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
    NSDictionary *arguments;
}

@property (strong, nonatomic) RSParagraph *paragraph;
@property (strong, nonatomic) RSNote *note;

+ (id) createNoteWithArguments: (NSDictionary *)args forParagarph: (RSParagraph *)paragraph;
+ (id) createNoteWithArguments: (NSDictionary *)args forParagraph: (RSParagraph *)paragraph withDelegate: (id<RSAPIRequestDelegate>)delegate;
- (id) initWithArguments: (NSDictionary *)args andParagraph: (RSParagraph *)paragraph;

@end

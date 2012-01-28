//
//  ParagraphNotesRequest.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/24/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSAPIRequest.h"

@class RSParagraph;
// Notes are saved directly to the paragraph object
@interface ParagraphNotesRequest : RSAPIRequest {
    // The paragraph for which to request notes
    RSParagraph* _paragraph;
}

+ (id) notesForParagraph: (RSParagraph *)paragraph;

- (id) initWithParagraph: (RSParagraph *)paragraph;

@end

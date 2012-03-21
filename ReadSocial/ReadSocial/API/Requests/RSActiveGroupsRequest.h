//
//  RSActiveGroupsRequest.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 3/14/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSAPIRequest.h"

@class RSParagraph;
@interface RSActiveGroupsRequest : RSAPIRequest

+ (RSActiveGroupsRequest *) requestActiveGroupsForParagraph:(RSParagraph *)paragraph withDelegate:(id)delegate;
- (RSActiveGroupsRequest *) initWithParagraph:(RSParagraph *)paragraph;

/**
 Filter active groups by paragraph.
 */
@property (nonatomic, strong) RSParagraph *paragraph;

/**
 An array of NSStrings containing the names of active groups as received from the API.
 */
@property (nonatomic, strong, readonly) NSArray *groups;

@end

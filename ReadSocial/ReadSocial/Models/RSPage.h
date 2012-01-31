//
//  RSPage.h
//  ReadSocial
//
//  Note that RSPage is NOT a managed object.
//
//  Created by Daniel Pfeiffer on 1/30/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReadSocial.h"
#import "RSAPIRequest.h"

extern NSString* const RSParagraphUpdatedNoteCount;

@interface RSPage : NSObject <RSAPIRequestDelegate>

@property (strong, nonatomic) NSArray *paragraphs;
@property (strong, nonatomic) id<ReadSocialDataSource> datasource;
@property (strong, readonly) NSString *selection;

- (RSPage *) initWithDataSource: (id<ReadSocialDataSource>)pDatasource;

- (void) createParagraphs;
- (void) requestCommentCount;

@end

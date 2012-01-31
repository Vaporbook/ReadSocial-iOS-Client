//
//  ReadSocial.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/30/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RSPage;
@protocol ReadSocialDataSource;

@interface ReadSocial : NSObject

+ (RSPage *) initView: (id<ReadSocialDataSource>)view;
+ (void) setCurrentPage: (id<ReadSocialDataSource>)view;
+ (void) openReadSocialForParagraph: (NSString *)content inView: (UIView *)view;
+ (void) openReadSocialForSelectionInView: (UIView *)view;

@end

@protocol ReadSocialDataSource <NSObject>

/**
 The number of paragraphs this page contains.
 */
- (NSInteger) numberOfParagraphsOnPage;

/**
 The raw content for the paragraph at the specified index.
 */
- (NSString *) paragraphAtIndex: (NSInteger)index;

/**
 The bounding box for the paragraph on the screen.
 */
- (CGRect) rectForParagraphAtIndex: (NSInteger)index;

- (NSString *) paragraphAtSelection;

@end
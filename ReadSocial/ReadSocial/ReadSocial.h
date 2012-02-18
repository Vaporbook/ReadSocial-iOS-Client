//
//  ReadSocial.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/30/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSParagraph+Core.h"
#import "RSNote+Core.h"
#import "RSResponse+Core.h"
#import "RSUser+Core.h"

@class RSPage;
@protocol ReadSocialDataSource;

extern NSString* const ReadSocialUserSelectedParagraphNotification;
extern NSString* const ReadSocialUserWillComposeNoteNotification;
extern NSString* const ReadSocialUserDidComposeNoteNotification;
extern NSString* const ReadSocialUserWillComposeResponseNotification;
extern NSString* const ReadSocialUserDidComposeResponseNotification;
extern NSString* const ReadSocialParagraphNoteCountUpdatedNotification;
extern NSString* const ReadSocialUserDidChangeGroupNotification;

@interface ReadSocial : NSObject

+ (RSPage *) initView: (id<ReadSocialDataSource>)view;
+ (void) setCurrentPage: (id<ReadSocialDataSource>)view;
+ (void) openReadSocialForParagraph: (NSString *)content inView: (UIView *)view;
+ (void) openReadSocialForSelectionInView: (UIView *)view;

// API Methods //TODO: Implement API Methods
//- (NSNumber *) noteCountForRawParagraph: (NSString *)raw;
//- (NSArray *) notesForRawParagraph: (NSString *)raw;
//- (void) composeNote: (RSNote *)note forParagraph: (RSParagraph *)paragraph;
//- (NSArray *) responsesForNote: (RSNote *)note;
//- (void) composeResponse: (RSResponse *)response forNote: (RSNote *)note;
//- (NSArray *) groupsForParagraph: (RSParagraph *)paragraph;

@end

/**
 The ReadSocial delegate receives callbacks from the library when 
 the user interacts with the ReadSocial library.
 The library will notify the delegate when...
 - the user selects a paragraph.
 - the user is about to send a note to the server.
 - the user creates a note for a paragraph.
 - the user is about to create a response to a note.
 - the user creates a response to a note on a paragraph.
 - the note count for the paragraph is available/updated.
 - the user changed the group.
 */
@protocol ReadSocialDelegate <NSObject>

- (void) userDidSelectParagraph: (RSParagraph *)paragraph;
- (void) userWillComposeNote: (RSNote *)note;
- (void) userDidComposeNote: (RSNote *)note;
- (void) userWillComposeResponse: (RSResponse *)response;
- (void) userDidComposeResponse: (RSResponse *)response;
- (void) noteCountUpdatedForParagraph: (RSParagraph *) atIndex: (NSInteger)index;
- (void) userDidChangeGroup: (NSString *)newGroup;

@end

/**
 Implementing apps MUST implement the ReadSocialDataSource;
 the ReadSocialDataSource protocol is how the ReadSocial library knows
 how to communicate with the content provided by the app.
 */
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

/**
 The paragraph content relevant to the current selection on the page.
 This data is requested by the class method openReadSocialForSelectionInView
 which is intended to be invoked by a UIMenuItem.
 TODO: Consider removing the paragraphAtSelection delegate method as it is inconsistent with how other methods interact (based on paragraph index).
 */
- (NSString *) paragraphAtSelection;

/**
 Same as paragraphAtSelection, but instead of requesting the raw paragraph content,
 it is requesting the paragraph index at the selection.
 */
- (NSInteger) paragraphIndexAtSelection;

/**
 The text that is selected on the page. Again, this data is requested by the
 class method openReadSocialForSelectionInView which is intended to be invoked
 by a UIMenuItem. This data is requested in addition to the selected paragraph
 because ReadSocial is interested in the actual part of the paragraph that was
 highlighted when the user selected the ReadSocial UIMenuItem.
 */
- (NSString *) selectedText;

@end
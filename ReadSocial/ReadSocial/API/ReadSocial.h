//
//  ReadSocial.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/30/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSAPIRequest.h"

@class RSPage;
@class RSParagraph;
@class RSNote;
@class RSResponse;
@class RSUser;

@protocol ReadSocialDataSource;
@protocol ReadSocialDelegate;
@protocol ReadSocialUILibrary;

extern NSString* const ReadSocialUserSelectedParagraphNotification;
extern NSString* const ReadSocialUserUnselectedParagraphNotification;
extern NSString* const ReadSocialUserWillComposeNoteNotification;
extern NSString* const ReadSocialUserDidComposeNoteNotification;
extern NSString* const ReadSocialUserWillComposeResponseNotification;
extern NSString* const ReadSocialUserDidComposeResponseNotification;
extern NSString* const ReadSocialParagraphNoteCountUpdatedNotification;
extern NSString* const ReadSocialUserDidChangeGroupNotification;
extern NSString* const ReadSocialUserDidLoginNotification;
extern NSString* const ReadSocialUserDidLogoutNotification;

@interface ReadSocial : NSObject <RSAPIRequestDelegate>

/**
 The default network ID for this ReadSocial session.
 */
@property (nonatomic, strong) NSNumber *networkID;

/**
 Sets the app key; if both the appKey and appSecret are set, 
 then they will be sent in the Authorization header in each API request.
 */
@property (nonatomic, strong) NSString *appKey;

/**
 Sets the app secret; if both the appKey and appSecret are set, 
 then they will be sent in the Authorization header in each API request.
 */
@property (nonatomic, strong) NSString *appSecret;

/**
 The URL to attempt to use as the API.
 */
@property (nonatomic, strong) NSURL *apiURL;

/**
 An array of all the authentication providers supported by the app.
 */
@property (nonatomic, strong) NSMutableArray *authProviders;

/**
 The page the user is currently viewing.
 Contains references to each paragraph on the page as well as the datasource 
 reference to obtain more information as needed.
 */
@property (nonatomic, strong) RSPage *currentPage;

/**
 The group the user is currently using. All notes are filtered by this group.
 This property cannot be changed directly but can be modified with changeToGroupWithString.
 Changing the group will trigger a wipe of the persistent store and it will redownload all the data.
 */
@property (readonly, getter = getCurrentGroup) NSString *currentGroup;

/**
 Copied reference to the selected text when ReadSocial was activated.
 */
@property (strong, readonly) NSString *currentSelection;

/**
 User data for the currently authenticated user.
 */
@property (nonatomic, strong) RSUser *currentUser;

/**
 The default group for this app.
 Changing this value will not change the current group.
 This is generally only referred to on initial app launch as once the user sets
 a new group, that group will become the default group for subsequent app launches.
 */
@property (nonatomic, strong) NSString *defaultGroup;

/**
 Object to receive delegate notifications when the user interacts with the API.
 */
@property (nonatomic, strong) id<ReadSocialDelegate> delegate;

/**
 YES if the user is currently logged in; NO otherwise.
 */
@property (nonatomic, readonly) BOOL loggedIn;

/**
 UI Library
 */
@property (nonatomic, strong) id<ReadSocialUILibrary> readSocialUI;

/**
 Change the group frmo which the user is posting and receiving data.
 Changing the group will empty out the persistent store in preparation for the new content from the server.
 */
- (void) changeToGroupWithString: (NSString *) newGroup;


# pragma mark Delegate and Notification Triggers
- (void) userDidSelectParagraph:(RSParagraph *)paragraph atIndex: (NSInteger)index;
- (void) userDidUnselectParagraph;
//- (void) userWillComposeNote: (RSNote *)note;
- (void) userDidComposeNote: (RSNote *)note;
//- (void) userWillComposeResponse: (RSResponse *)response;
- (void) userDidComposeResponse: (RSResponse *)response;
- (void) noteCountUpdatedForParagraph: (RSParagraph *)paragraph atIndex: (NSInteger)index;
- (void) userDidChangeGroup: (NSString *)newGroup;
- (void) userDidLogin: (RSUser *)user;
- (void) userDidLogout;

# pragma mark Methods
- (RSPage *) initializeView: (id<ReadSocialDataSource>)view;
+ (void) setCurrentPage: (id<ReadSocialDataSource>)view;
+ (void) setCurrentPageAndDelegate: (id<ReadSocialDataSource>)view;
+ (void) openReadSocialForParagraph: (RSParagraph *)paragaph inView: (UIView *)view;
+ (void) openReadSocialForRawParagraph: (NSString *)content inView: (UIView *)view;
+ (void) openReadSocialForSelectionInView: (UIView *)view;

// Convenience accessors
+ (NSNumber *) networkID;
+ (NSString *) currentGroup;
+ (RSPage *) currentPage;
+ (NSManagedObjectContext *) dataContext;
+ (void) saveContext;

+ (ReadSocial *) sharedInstance;
+ (ReadSocial *) initializeWithNetworkID: (NSNumber *)networkID defaultGroup: (NSString *)defaultGroup andUILibrary:(id<ReadSocialUILibrary>)ui;

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

@optional
- (void) userDidSelectParagraph:(RSParagraph *)paragraph atIndex: (NSInteger)index;
- (void) userDidUnselectParagraph;
//- (void) userWillComposeNote: (RSNote *)note;
- (void) userDidComposeNote: (RSNote *)note;
//- (void) userWillComposeResponse: (RSResponse *)response;
- (void) userDidComposeResponse: (RSResponse *)response;
- (void) noteCountUpdatedForParagraph: (RSParagraph *)paragraph atIndex: (NSInteger)index;
- (void) userDidChangeGroup: (NSString *)newGroup;
- (void) userDidLogin: (RSUser *)user;
- (void) userDidLogout;

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
//RETIRED- (NSString *) paragraphAtSelection;

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

@protocol ReadSocialUILibrary <NSObject>

- (void) openReadSocialForParagraph:(RSParagraph *)paragraph frame:(CGRect)frame view:(UIView *)view;

@end
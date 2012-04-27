//
//  AppDelegate.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/21/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString* const kEmulateSSO;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UIViewController *viewController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
- (void) resetStore;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void) checkForManualUserData;

@end

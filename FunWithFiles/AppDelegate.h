//
//  AppDelegate.h
//  FunWithFiles
//
//  Created by Alexandre ARRIGHI on 29/01/2016.
//  Copyright © 2016 Alexandre ARRIGHI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class FWFFilesWebService;
@class FWFPersistentStack;
@class FWFFileImporter;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) FWFPersistentStack *persistentStack;
@property (nonatomic, strong) FWFFilesWebService *webservice;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end



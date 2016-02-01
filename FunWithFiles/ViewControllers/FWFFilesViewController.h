//
//  FWFFilesViewController.h
//  FunWithFiles
//
//  Created by Alexandre ARRIGHI on 30/01/2016.
//  Copyright © 2016 Alexandre ARRIGHI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FWFFile.h"

@interface FWFFilesViewController : UITableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) FWFFile *file;
@property (nonatomic) BOOL isSubFolder;

@end

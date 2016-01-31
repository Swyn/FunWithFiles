//
//  FWFFetchedResultsControllerDataSource.h
//  FunWithFiles
//
//  Created by Alexandre ARRIGHI on 30/01/2016.
//  Copyright © 2016 Alexandre ARRIGHI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSFetchedResultsController;

@protocol FWFFetechedResultsControllerDataSourceDelegate

-(void)configureCell:(id)cell withObject:(id)object;
-(void)deleteObject:(id)object;

@end

@interface FWFFetchedResultsControllerDataSource : NSObject <UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) id<FWFFetechedResultsControllerDataSourceDelegate> delegate;
@property (copy, nonatomic) NSString *reuseIdentifier;
@property (nonatomic) BOOL paused;

-(id)initWithTableView:(UITableView *)tableView;
-(id)objectAtIndexPath:(NSIndexPath *)indexPath;
-(id)selectedItem;



@end

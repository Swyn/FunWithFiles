//
//  FWFFetchedResultsControllerDataSource.m
//  FunWithFiles
//
//  Created by Alexandre ARRIGHI on 30/01/2016.
//  Copyright © 2016 Alexandre ARRIGHI. All rights reserved.
//

#import "FWFFetchedResultsControllerDataSource.h"
#import "FWFFilesTableViewCell.h"

@interface FWFFetchedResultsControllerDataSource ()

@property (weak, nonatomic) UITableView *tableView;

@end

@implementation FWFFetchedResultsControllerDataSource


- (id)initWithTableView:(UITableView*)tableView
{
    self = [super init];
    if (self) {
        self.tableView = tableView;
        self.tableView.dataSource = self;
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    /*
     We ask the fetchResultController to return it's array of sections and we return their count.
    */
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    
    //We ask the array of sections and also the object within the array
    id<NSFetchedResultsSectionInfo> section = self.fetchedResultsController.sections[sectionIndex];
    return [section numberOfObjects];
}


- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    //configuration of table view cell with a delegate
    id object = [self objectAtIndexPath:indexPath];
    id cell = [tableView dequeueReusableCellWithIdentifier:self.reuseIdentifier forIndexPath:indexPath];
    [self.delegate configureCell:cell withObject:object];
    return cell;
}

- (id)objectAtIndexPath:(NSIndexPath*)indexPath
{
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
}


#pragma mark NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController*)controller
{
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController*)controller
{
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController*)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath*)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath*)newIndexPath
{
    
    //check for NSFetchResult updates
    
    if (type == NSFetchedResultsChangeInsert) {
        [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else if (type == NSFetchedResultsChangeMove) {
        [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
    } else if (type == NSFetchedResultsChangeDelete) {
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else if (type == NSFetchedResultsChangeUpdate) {
        if ([self.tableView.indexPathsForVisibleRows containsObject:indexPath]) {
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    } else {
        NSAssert(NO,@"");
    }
}

- (void)setFetchedResultsController:(NSFetchedResultsController*)fetchedResultsController
{
    //NSFecthResultController setter
    
    _fetchedResultsController = fetchedResultsController;
    fetchedResultsController.delegate = self;
    [fetchedResultsController performFetch:NULL];
}


- (id)selectedItem
{
    //return selected Item
    NSIndexPath* path = self.tableView.indexPathForSelectedRow;
    return path ? [self.fetchedResultsController objectAtIndexPath:path] : nil;
}



@end

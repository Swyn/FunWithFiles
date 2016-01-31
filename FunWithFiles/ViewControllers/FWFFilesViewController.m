//
//  FWFFilesViewController.m
//  FunWithFiles
//
//  Created by Alexandre ARRIGHI on 30/01/2016.
//  Copyright © 2016 Alexandre ARRIGHI. All rights reserved.
//

#import "FWFFilesViewController.h"
#import "FWFFetchedResultsControllerDataSource.h"
#import "FWFFile.h"

@interface FWFFilesViewController () <FWFFetechedResultsControllerDataSourceDelegate>

@property (strong, nonatomic) FWFFetchedResultsControllerDataSource *dataSource;

@end

@implementation FWFFilesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"File"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"file" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"mimetype" ascending:NO]];
    
    self.dataSource = [[FWFFetchedResultsControllerDataSource alloc] initWithTableView:self.tableView];
    self.dataSource.delegate = self;
    self.dataSource.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    self.dataSource.reuseIdentifier = @"Cell";

}

- (void)configureCell:(UITableViewCell *)cell withObject:(FWFFile*)object
{
    cell.textLabel.text = object.file;
    cell.detailTextLabel.text = object.mimetype;
}


- (void)deleteObject:(id)object
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

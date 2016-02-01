//
//  FWFFilesViewController.m
//  FunWithFiles
//
//  Created by Alexandre ARRIGHI on 30/01/2016.
//  Copyright © 2016 Alexandre ARRIGHI. All rights reserved.
//

#import "FWFFilesViewController.h"
#import "FWFFetchedResultsControllerDataSource.h"

#import "FWFImageViewController.h"
#import "FWFVideoViewController.h"
#import "FWFFilesWebService.h"
#import "FWFFileImporter.h"
#import "FWFPersistentStack.h"

@interface FWFFilesViewController () <FWFFetechedResultsControllerDataSourceDelegate>

@property (strong, nonatomic) FWFFetchedResultsControllerDataSource *dataSource;

@end

@implementation FWFFilesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if (!self.isSubFolder) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"File"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"file" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"mimetype" ascending:NO]];
        
        self.dataSource = [[FWFFetchedResultsControllerDataSource alloc] initWithTableView:self.tableView];
        self.dataSource.delegate = self;
        self.dataSource.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        self.dataSource.reuseIdentifier = @"Cell";
    }else {
        FWFFilesWebService *webservice = [[FWFFilesWebService alloc] init];
        NSManagedObjectContext *objectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        objectContext.parentContext = self.managedObjectContext;
        [objectContext performBlock:^{
            FWFFileImporter *importer = [[FWFFileImporter alloc] initWithContext:objectContext webservice:webservice];
            importer.currentPath = self.file.path;
            [importer importAtPath:self.file.file];
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"File"];
            [NSFetchedResultsController deleteCacheWithName:@"File"];
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"parent.file == %@", self.file.file];
            [request setPredicate:pred];
            request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"file" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"mimetype" ascending:NO]];
            self.dataSource = [[FWFFetchedResultsControllerDataSource alloc] initWithTableView:self.tableView];
            self.dataSource.delegate = self;
            self.dataSource.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:objectContext sectionNameKeyPath:nil cacheName:nil];
            self.dataSource.reuseIdentifier = @"Cell";
        }];
        
    }
   

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FWFFile *selectedFile = self.dataSource.selectedItem;
    
    if ([selectedFile.mimetype isEqualToString:@"video/mp4"]) {
        FWFVideoViewController *vc = (FWFVideoViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"FWFVideoViewController"];
        vc.file = selectedFile;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([selectedFile.mimetype isEqualToString:@"inode/directory"]){
        
        FWFFilesViewController *vc = (FWFFilesViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"FWFFilesViewController"];
        vc.isSubFolder = YES;
        vc.file = selectedFile;
        vc.managedObjectContext = [self managedObjectContext];
        vc.file.parentFolder = selectedFile;
//        NSManagedObjectContext *context = nil;
//        NSUInteger type = NSPrivateQueueConcurrencyType;
//        context = [[NSManagedObjectContext alloc] initWithConcurrencyType:type];
//        [context setParentContext:[self managedObjectContext]];
//        vc.managedObjectContext = context;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
    FWFImageViewController *VC = (FWFImageViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"FWFImageViewController"];
    VC.file = selectedFile;
    [self.navigationController pushViewController:VC animated:YES];
    }
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    FWFImageViewController *detailViewController = segue.destinationViewController;
    detailViewController.file = self.dataSource.selectedItem;
}

- (NSURL*)storeURL
{
    NSURL* documentsDirectory = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                                       inDomain:NSUserDomainMask
                                                              appropriateForURL:nil
                                                                         create:YES
                                                                          error:NULL];
    return [documentsDirectory URLByAppendingPathComponent:@"db.sqlite"];
}

- (NSURL*)modelURL
{
    return [[NSBundle mainBundle] URLForResource:@"FunWithFiles" withExtension:@"momd"];
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

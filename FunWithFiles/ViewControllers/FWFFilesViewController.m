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
#import "FWFMusicViewController.h"
#import "FWFFilesWebService.h"

#import "FWFFilesTableViewCell.h"

#import "FWFFileImporter.h"
#import "FWFPersistentStack.h"

#import <Foundation/Foundation.h>

@interface FWFFilesViewController () <FWFFetechedResultsControllerDataSourceDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) FWFFetchedResultsControllerDataSource *dataSource;
@property (strong, nonatomic) UIRefreshControl *refreshController;

@property (weak, nonatomic) IBOutlet UILabel *topBarLabel;
@property (strong, nonatomic) UIImage *imageToUpload;


@end

@implementation FWFFilesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initRefreshController];
    [self setupView];
    if (self.isSubFolder) {
        self.topBarLabel.text = [NSString stringWithFormat:@"%@", self.file.fileName];
    }else{
        self.topBarLabel.text = @"Home";
    }
   }

-(void)setupView{
    
    FWFFilesWebService *webService = [[FWFFilesWebService alloc] init];
    FWFFileImporter *importer = [[FWFFileImporter alloc] initWithContext:[self managedObjectContext] webservice:webService];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"File"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"fileName" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"mimetype" ascending:NO]];
    NSPredicate *pred;
    
    if (!self.isSubFolder) {
        [importer importAtPath:nil withFile:nil];
        pred = [NSPredicate predicateWithFormat:@"parentFile == nil"];
    }else {
        importer.currentPath = self.file.path;
        [importer importAtPath:self.file.fileName withFile:self.file];
        pred = [NSPredicate predicateWithFormat:@"parentFile == %@", self.file];
    }
    
    [request setPredicate:pred];
    
    self.dataSource = [[FWFFetchedResultsControllerDataSource alloc] initWithTableView:self.tableView];
    self.dataSource.delegate = self;
    self.dataSource.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    self.dataSource.reuseIdentifier = @"Cell";
    
    if (self.refreshController) {
         [self.refreshController endRefreshing];
    }

    
}

-(void)initRefreshController{
    
    //Refresher initialisation
    self.refreshController = [[UIRefreshControl alloc] init];
    self.refreshController.backgroundColor = [UIColor purpleColor];
    self.refreshController.tintColor = [UIColor whiteColor];
    
    [self.tableView addSubview:self.refreshController];
    
    [self.refreshController addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
}

-(void)refreshTable{
    [self setupView];
}

- (IBAction)addBarButtonItemTouched:(UIBarButtonItem *)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Action" message:@"Choisissez une option" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Ajouter un dossier" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [self addFolderAction];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Ajouter une photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self showPhotoOptionAlert];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Annuler" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(void)showPhotoOptionAlert{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Action" message:@"Choisissez une option" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Depuis vos Albums" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:NULL];

    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Prendre une photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:NULL];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Annuler" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    self.imageToUpload = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self addImage];
    }];
    
}

-(void)addImage{
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Ajouter une Image"
                                          message:@"Entrez un nom pour l'image"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = @"Nom de l'image";
     }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Valider"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   [[self managedObjectContext] performBlockAndWait:^{
                                       [self addImageWithName:alertController.textFields.firstObject.text];
                                       NSError *error;
                                       [[self managedObjectContext] save:&error];
                                       if (!error) {
                                           [self setupView];
                                       }
                                   }];
                                   [self dismissViewControllerAnimated:YES completion:nil];
                                   
                               }];
    UIAlertAction *cancelAction =[UIAlertAction actionWithTitle:@"Annuler"
                                                          style:UIAlertActionStyleCancel
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            [self dismissViewControllerAnimated:YES completion:nil];
                                                        }];
    
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    

    
}

-(void)addImageWithName:(NSString *)name{
    
    NSString *urlString;
    
    if (!self.isSubFolder) {
        urlString = [NSString stringWithFormat:@"http://ioschallenge.api.meetlima.com/%@", name];
    }else{
        urlString = [NSString stringWithFormat:@"http://ioschallenge.api.meetlima.com%@/%@?stat", self.file.path, name];
    }
    
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"PUT";
    
    NSData *imageData = UIImageJPEGRepresentation(self.imageToUpload, 1.0);
    NSURLSessionUploadTask *task = [session uploadTaskWithRequest:request fromData:imageData completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    }];
    [task resume];
    
}


-(void)addFolderAction{
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Ajouter un Dossier"
                                          message:@"Entrez un nom pour le nouveau dossier"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = @"Nom du dossier";
     }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Valider"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   [[self managedObjectContext] performBlockAndWait:^{
                                       [self addFolderWithName:alertController.textFields.firstObject.text];
                                       NSError *error;
                                       [[self managedObjectContext] save:&error];
                                       if (!error) {
                                           [self setupView];
                                       }
                                   }];
                                   [self dismissViewControllerAnimated:YES completion:nil];
                                   
                               }];
    UIAlertAction *cancelAction =[UIAlertAction actionWithTitle:@"Annuler"
                                                        style:UIAlertActionStyleCancel
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            [self dismissViewControllerAnimated:YES completion:nil];
                                                        }];
    
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}


-(void)addFolderWithName:(NSString *)name {
    
    NSString *urlString;
    
    if (!self.isSubFolder) {
        urlString = [NSString stringWithFormat:@"http://ioschallenge.api.meetlima.com/%@", name];
    }else{
        urlString = [NSString stringWithFormat:@"http://ioschallenge.api.meetlima.com%@/%@?stat", self.file.path, name];
    }
    
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"PUT";
    
    NSURLSessionDataTask *dataSession = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    }];
    
    [dataSession resume];
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
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([selectedFile.mimetype containsString:@"audio"]){
        FWFMusicViewController *vc = (FWFMusicViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"FWFMusicViewController"];
        vc.file = selectedFile;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else{
    FWFImageViewController *VC = (FWFImageViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"FWFImageViewController"];
    VC.file = selectedFile;
    [self.navigationController pushViewController:VC animated:YES];
    }
}

- (void)configureCell:(FWFFilesTableViewCell *)cell withObject:(FWFFile*)object
{
    cell.fileName.text = object.fileName;
    if ([object.mimetype containsString:@"audio"]) {
        cell.image.image = [UIImage imageNamed:@"Music"];
    }else if ([object.mimetype containsString:@"directory"]){
        cell.image.image = [UIImage imageNamed:@"Folder"];
    }else if ([object.mimetype containsString:@"video"]){
        cell.image.image = [UIImage imageNamed:@"Video"];
    }else if ([object.mimetype containsString:@"image"]){
        cell.image.image = [UIImage imageNamed:@"Picture"];
    }else
        cell.image.image = [UIImage imageNamed:@"Unknown"];
    
}


- (void)deleteObject:(id)object
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    FWFImageViewController *detailViewController = segue.destinationViewController;
//    detailViewController.file = self.dataSource.selectedItem;
//}

@end

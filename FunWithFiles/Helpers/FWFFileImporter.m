//
//  FWFFileImporter.m
//  FunWithFiles
//
//  Created by Alexandre ARRIGHI on 29/01/2016.
//  Copyright © 2016 Alexandre ARRIGHI. All rights reserved.
//

#import "FWFFileImporter.h"
#import "FWFFilesWebService.h"


@interface FWFFileImporter ()

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) FWFFilesWebService *webservice;

@end

@implementation FWFFileImporter

- (id)initWithContext:(NSManagedObjectContext *)context webservice:(FWFFilesWebService *)webservice
{
    self = [super init];
    if (self) {
        self.context = context;
        self.webservice = webservice;
    }
    return self;
}

-(void)importAtPath:(NSString *)path withFile:(FWFFile *)file{
{
    //First we ask for all files then we go grab metadatas for each of them
    
    __weak FWFFile *weakFile = file;
    [self.webservice fetchAllFilesAtPath:path withCallBack:^(NSArray *files)
     {
         for(NSString *fileStat in files) {
             [self.webservice fetchMetadaForFile:fileStat atPath:self.currentPath withCallback:^(NSDictionary *dict){
                 NSLog(@"%@", dict);
                 [self.context performBlock:^
                  {
                      FWFFile *file = [FWFFile findOrCreateFileWithIdentifier:fileStat inContext:self.context];
                      [file loadFromDictionary:dict withParentFile:weakFile];
                      NSError *error = nil;
                      [self.context save:&error];
                      if (error) {
                          NSLog(@"Error: %@", error.localizedDescription);
                      }
                  }];
             }];
         }
     }];
    }
}


@end

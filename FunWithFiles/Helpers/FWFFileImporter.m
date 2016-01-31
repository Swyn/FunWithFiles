//
//  FWFFileImporter.m
//  FunWithFiles
//
//  Created by Alexandre ARRIGHI on 29/01/2016.
//  Copyright © 2016 Alexandre ARRIGHI. All rights reserved.
//

#import "FWFFileImporter.h"
#import "FWFFilesWebService.h"
#import "FWFFile.h"

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

-(void)importAtPath:(NSString *)path{
{
    [self.webservice fetchAllFilesAtPath:path withCallBack:^(NSArray *files)
     {
         for(NSString *fileStat in files) {
             [self.webservice fetchMetadaForFile:fileStat withCallback:^(NSDictionary *dict){
                 NSLog(@"%@", dict);
                 
                 [self.context performBlock:^
                  {
                      FWFFile *file = [FWFFile findOrCreateFileWithIdentifier:fileStat inContext:self.context];
                      [file loadFromDictionary:dict];
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

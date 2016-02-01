//
//  FWFFileImporter.h
//  FunWithFiles
//
//  Created by Alexandre ARRIGHI on 29/01/2016.
//  Copyright © 2016 Alexandre ARRIGHI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWFFilesWebService.h"
#import "FWFFile.h"

@interface FWFFileImporter : NSObject

@property (nonatomic, strong) NSString *currentPath;
@property (nonatomic, strong) FWFFile *parentFile;

-(id)initWithContext:(NSManagedObjectContext *)context webservice:(FWFFilesWebService *)webservice;
-(void)importAtPath:(NSString *)path;

@end

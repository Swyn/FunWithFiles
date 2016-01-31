//
//  FWFFileImporter.h
//  FunWithFiles
//
//  Created by Alexandre ARRIGHI on 29/01/2016.
//  Copyright © 2016 Alexandre ARRIGHI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWFFilesWebService.h"

@interface FWFFileImporter : NSObject

-(id)initWithContext:(NSManagedObjectContext *)context webservice:(FWFFilesWebService *)webservice;
-(void)importAtPath:(NSString *)path;

@end

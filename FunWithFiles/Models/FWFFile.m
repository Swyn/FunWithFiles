//
//  FWFFile.m
//  FunWithFiles
//
//  Created by Alexandre ARRIGHI on 01/02/2016.
//  Copyright © 2016 Alexandre ARRIGHI. All rights reserved.
//

#import "FWFFile.h"

@implementation FWFFile

- (void)loadFromDictionary:(NSDictionary *)dictionary withParentFile:(FWFFile *)file
{
    //Object update
    self.fileName = dictionary[@"file"];
    self.mimetype = dictionary[@"mimetype"];
    self.changeTime = [NSString stringWithFormat:@"%@", dictionary[@"change_time"]] ;
    self.accessTime = [NSString stringWithFormat:@"%@", dictionary[@"access_time"]];
    self.modificationTime = [NSString stringWithFormat:@"%@", dictionary[@"modification_time"]];
    self.path = dictionary[@"path"];
    self.parentFile = file;
}


+ (FWFFile *)findOrCreateFileWithIdentifier:(NSString *)name inContext:(NSManagedObjectContext *)context
{
    //add object to context
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"File"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"fileName == %@",name];
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"error: %@", error.localizedDescription);
    }
    if (result.lastObject) {
        return result.lastObject;
    } else {
        
        FWFFile *file = (FWFFile *)[FWFModelObject insertNewObjectIntoContext:context];
        file.fileName = name;
        return file;
    }
}

@end

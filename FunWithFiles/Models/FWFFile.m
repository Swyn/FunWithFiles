//
//  FWFFile.m
//  FunWithFiles
//
//  Created by Alexandre ARRIGHI on 30/01/2016.
//  Copyright © 2016 Alexandre ARRIGHI. All rights reserved.
//

#import "FWFFile.h"

@implementation FWFFile

@dynamic file;
@dynamic mimetype;
@dynamic changeTime;
@dynamic accessTime;
@dynamic modificationTime;
@dynamic path;
@dynamic size;

- (void)loadFromDictionary:(NSDictionary *)dictionary
{
    self.file = dictionary[@"file"];
    self.mimetype = dictionary[@"mimetype"];
    self.changeTime = [NSString stringWithFormat:@"%@", dictionary[@"change_time"]] ;
    self.accessTime = [NSString stringWithFormat:@"%@", dictionary[@"access_time"]];
    self.modificationTime = [NSString stringWithFormat:@"%@", dictionary[@"modification_time"]];
    self.path = dictionary[@"path"];
//    self.size = dictionary[@"size"];
}

+ (FWFFile *)findOrCreateFileWithIdentifier:(NSString *)name inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"File"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"file == %@",name];
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"error: %@", error.localizedDescription);
    }
    if (result.lastObject) {
        return result.lastObject;
    } else {
        
        FWFFile *file = [self insertNewObjectIntoContext:context];
        file.file = name;
        return file;
    }
}

@end

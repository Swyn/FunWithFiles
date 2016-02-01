//
//  FWFFile.h
//  FunWithFiles
//
//  Created by Alexandre ARRIGHI on 30/01/2016.
//  Copyright © 2016 Alexandre ARRIGHI. All rights reserved.
//
/*
 File :
 {
 "mimetype": "audio/mpeg",
 "change_time": 1439824686,
 "access_time": 1454109453,
 "modification_time": 1439574725,
 "file": "12. The Experience.mp3",
 "path": "/Skyzoo - Music For My Friends/12. The Experience.mp3",
 "size": 8646574
 }
 Path :
 {
 "mimetype": "inode/directory",
 "change_time": 1442286283,
 "access_time": 1454076644,
 "modification_time": 1442286283,
 "file": "",
 "path": "/"
 }
 */
#import <Foundation/Foundation.h>
#import "FWFModelObject.h"

@interface FWFFile : FWFModelObject

@property (nonatomic, retain) NSString *mimetype;
@property (nonatomic, retain) NSString *changeTime;
@property (nonatomic, retain) NSString *accessTime;
@property (nonatomic, retain) NSString *modificationTime;
@property (nonatomic, retain) NSString *file;
@property (nonatomic, retain) NSString *path;
@property (nonatomic, retain) NSString *size;

@property (nonatomic, retain) FWFFile *parentFolder;
@property (nonatomic, retain) FWFFile *subFolder;


- (void)loadFromDictionary:(NSDictionary *)dictionary;
+ (FWFFile *)findOrCreateFileWithIdentifier:(NSString *)name inContext:(NSManagedObjectContext *)context;

@end

//
//  FWFFile+CoreDataProperties.h
//  FunWithFiles
//
//  Created by Alexandre ARRIGHI on 01/02/2016.
//  Copyright © 2016 Alexandre ARRIGHI. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "FWFFile.h"

NS_ASSUME_NONNULL_BEGIN

@interface FWFFile (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *accessTime;
@property (nullable, nonatomic, retain) NSString *changeTime;
@property (nullable, nonatomic, retain) NSString *fileName;
@property (nullable, nonatomic, retain) NSString *mimetype;
@property (nullable, nonatomic, retain) NSString *modificationTime;
@property (nullable, nonatomic, retain) NSString *path;
@property (nullable, nonatomic, retain) FWFFile *parentFile;
@property (nullable, nonatomic, retain) NSSet<FWFFile *> *subFile;

@end

@interface FWFFile (CoreDataGeneratedAccessors)

- (void)addSubFileObject:(FWFFile *)value;
- (void)removeSubFileObject:(FWFFile *)value;
- (void)addSubFile:(NSSet<FWFFile *> *)values;
- (void)removeSubFile:(NSSet<FWFFile *> *)values;

@end

NS_ASSUME_NONNULL_END

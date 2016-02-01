//
//  FWFFile.h
//  FunWithFiles
//
//  Created by Alexandre ARRIGHI on 01/02/2016.
//  Copyright © 2016 Alexandre ARRIGHI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "FWFModelObject.h"  

NS_ASSUME_NONNULL_BEGIN

@interface FWFFile : NSManagedObject

- (void)loadFromDictionary:(NSDictionary *)dictionary withParentFile:(FWFFile *)file;
+ (FWFFile *)findOrCreateFileWithIdentifier:(NSString *)name inContext:(NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END

#import "FWFFile+CoreDataProperties.h"

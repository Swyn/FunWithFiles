//
//  FWFFilesWebService.h
//  FunWithFiles
//
//  Created by Alexandre ARRIGHI on 29/01/2016.
//  Copyright © 2016 Alexandre ARRIGHI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface FWFFilesWebService : NSObject

-(void)fetchAllFiles:(void (^)(NSArray *files))callback;
-(void)fetchMetadaForFile:(NSString *)fileName withCallback:(void(^)(NSDictionary *dictionary))callback;

@end




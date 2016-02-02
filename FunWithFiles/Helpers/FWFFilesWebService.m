//
//  FWFFilesWebService.m
//  FunWithFiles
//
//  Created by Alexandre ARRIGHI on 29/01/2016.
//  Copyright © 2016 Alexandre ARRIGHI. All rights reserved.
//

#import "FWFFilesWebService.h"

@interface FWFFilesWebService ()

//@property (nonatomic, strong) NSURLSessionDataTask *task;

@end

@implementation FWFFilesWebService


-(void)fetchAllFilesAtPath:(NSString *)path withCallBack:(void (^)(NSArray *files))callback{
    NSString *urlString;
    
    if (path == nil) {
        urlString = [NSString stringWithFormat:@"http://ioschallenge.api.meetlima.com/"];
    }else{
        urlString = [NSString stringWithFormat:@"http://ioschallenge.api.meetlima.com/%@", path];
        urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:
      ^(NSData *data, NSURLResponse *response, NSError *error) {
          if (error) {
              NSLog(@"error: %@", error.localizedDescription);
              callback(nil);
              return;
          }
          NSError *jsonError = nil;
          id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
          if ([result isKindOfClass:[NSArray class]]) {
              NSArray *pods = result;
              callback(pods);
          }
      }] resume];
}


-(void)fetchMetadaForFile:(NSString *)fileName atPath:(NSString *)path withCallback:(void(^)(NSDictionary *dictionary))callback{
    NSString *urlString;
    
    if (path == nil) {
        urlString = [NSString stringWithFormat:@"http://ioschallenge.api.meetlima.com/%@?stat", fileName];
    }else{
        urlString = [NSString stringWithFormat:@"http://ioschallenge.api.meetlima.com%@/%@?stat", path, fileName];
    }
    
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error : %@", error.localizedDescription);
            callback(nil);
            return;
        }
        NSError *jsonError = nil;
        id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *metaFile = result;
            callback(metaFile);
        }
    }] resume];
    
}




@end

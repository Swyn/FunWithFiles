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

-(void)addImageAtPath:(NSString *)path withName:(NSString *)name andImage:(UIImage *)image{
    
    
    NSString *urlString;
    
    if (!path) {
        urlString = [NSString stringWithFormat:@"http://ioschallenge.api.meetlima.com/%@", name];
    }else{
        urlString = [NSString stringWithFormat:@"http://ioschallenge.api.meetlima.com%@/%@?stat",path, name];
    }
    
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"PUT";
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    NSURLSessionUploadTask *task = [session uploadTaskWithRequest:request fromData:imageData completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    }];
    [task resume];

    
}

-(void)addFolderAtPath:(NSString *)path withName:(NSString *)name {
    
    NSString *urlString;
    
    if (!path) {
        urlString = [NSString stringWithFormat:@"http://ioschallenge.api.meetlima.com/%@", name];
    }else{
        urlString = [NSString stringWithFormat:@"http://ioschallenge.api.meetlima.com%@/%@?stat", path, name];
    }
    
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"PUT";
    
    NSURLSessionDataTask *dataSession = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    }];
    
    [dataSession resume];

    
}




@end

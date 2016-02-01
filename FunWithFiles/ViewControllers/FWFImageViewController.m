//
//  FWFImageViewController.m
//  FunWithFiles
//
//  Created by Alexandre ARRIGHI on 31/01/2016.
//  Copyright © 2016 Alexandre ARRIGHI. All rights reserved.
//

#import "FWFImageViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface FWFImageViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation FWFImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getAndDisplayImage];
    // Do any additional setup after loading the view.
}

-(void)getAndDisplayImage{
    
    
    NSString *urlString = [NSString stringWithFormat:@"http://ioschallenge.api.meetlima.com/%@", self.file.fileName];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    
    [self.imageView sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

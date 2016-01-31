//
//  FWFVideoViewController.m
//  FunWithFiles
//
//  Created by Alexandre ARRIGHI on 31/01/2016.
//  Copyright © 2016 Alexandre ARRIGHI. All rights reserved.
//

#import "FWFVideoViewController.h"
#import <VKVideoPlayer/VKVideoPlayer.h>

@interface FWFVideoViewController ()<VKVideoPlayerDelegate>

@property (nonatomic, strong) VKVideoPlayer* player;

@end

@implementation FWFVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getAndPlayVideo];
    // Do any additional setup after loading the view.
}

-(void)getAndPlayVideo{
    
    NSString *urlString = [NSString stringWithFormat:@"http://ioschallenge.api.meetlima.com/%@", self.file.file];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    
    VKVideoPlayerTrack *track = [[VKVideoPlayerTrack alloc] init];
    track.streamURL = url;
    self.player = [[VKVideoPlayer alloc] initWithVideoPlayerView:[[VKVideoPlayerView alloc] init]];
    self.player.view.frame = self.view.bounds;
    self.player.delegate = self;
    [self.view addSubview:self.player.view];
    [self.player loadVideoWithStreamURL:url];
    
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

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
    self.player = [[VKVideoPlayer alloc] initWithVideoPlayerView:[[VKVideoPlayerView alloc] init]];
    self.player.view.frame = self.view.bounds;
    self.player.delegate = self;
    [self getAndPlayVideo];
    self.title = [NSString stringWithFormat:@"%@", self.file.fileName];
    // Do any additional setup after loading the view.
}

-(void)getAndPlayVideo{
    
    NSString *urlString = [NSString stringWithFormat:@"http://ioschallenge.api.meetlima.com/%@", self.file.fileName];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    VKVideoPlayerTrack *track = [[VKVideoPlayerTrack alloc] init];
    track.streamURL = url;
    [self.view addSubview:self.player.view];
    [self.player loadVideoWithStreamURL:url];
    
}

-(void)videoPlayer:(VKVideoPlayer *)videoPlayer didChangeStateFrom:(VKVideoPlayerState)fromState{
    if (fromState != VKVideoPlayerStateContentPlaying) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }else
        [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)videoPlayer:(VKVideoPlayer *)videoPlayer didControlByEvent:(VKVideoPlayerControlEvent)event{
    
    if (event == VKVideoPlayerControlEventTapDone) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else if (event == VKVideoPlayerControlEventTapPlayerView && self.player.state == VKVideoPlayerStateContentPaused){
        [self.player playContent];
    }else if (event == VKVideoPlayerControlEventTapPlayerView && self.player.state == VKVideoPlayerStateContentPlaying){
         [self.player pauseContent];
    }
    
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

//
//  FWFMusicViewController.m
//  FunWithFiles
//
//  Created by Alexandre ARRIGHI on 01/02/2016.
//  Copyright © 2016 Alexandre ARRIGHI. All rights reserved.
//

#import "FWFMusicViewController.h"
#import <OrigamiEngine/ORGMEngine.h>

@interface FWFMusicViewController ()<ORGMEngineDelegate>

@property (strong, nonatomic) ORGMEngine *player;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UILabel *playedLabel;
@property (weak, nonatomic) IBOutlet UILabel *toPlayLabel;
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) NSTimer *refreshTimer;

@end

@implementation FWFMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.player = [[ORGMEngine alloc] init];
    self.player.delegate = self;
    
    NSString *urlString = [NSString stringWithFormat:@"http://ioschallenge.api.meetlima.com%@", self.file.path];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    self.url = [NSURL URLWithString:urlString];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                         target:self
                                                       selector:@selector(refreshUI)
                                                       userInfo:nil
                                                        repeats:YES];

}



- (void)refreshUI {
    if (self.player.currentState == ORGMEngineStatePlaying) {
        self.playedLabel.text = [NSString stringWithFormat:@"%.1f",
                              self.player.amountPlayed];
        self.slider.value = self.player.amountPlayed;
    }
}
- (IBAction)playedButtonTouched:(UIButton *)sender {
    
    if (self.player.currentState == ORGMEngineStatePaused) {
        [self.player resume];
    }else if (self.player.currentState == ORGMEngineStatePlaying){
        [self.player pause];
    }else{
        [self.player playUrl:self.url];
        self.toPlayLabel.text = [NSString stringWithFormat:@"%.1f", self.player.trackTime];
    }
    
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    [self.player seekToTime:self.slider.value];
}

- (void)engine:(ORGMEngine *)engine didChangeState:(ORGMEngineState)state {
    switch (state) {
        case ORGMEngineStateStopped: {
            self.slider.value = 0.0;
            self.playedLabel.text = @"Waiting...";
            [self.playButton setEnabled:YES];
//            [btnPause setTitle:NSLocalizedString(@"Pause", nil)
//                      forState:UIControlStateNormal];
            break;
        }
        case ORGMEngineStatePaused: {
            [self.playButton setTitle:NSLocalizedString(@"Play", nil)
                      forState:UIControlStateNormal];
            break;
        }
        case ORGMEngineStatePlaying: {
            [self.playButton setTitle:NSLocalizedString(@"Pause", nil) forState:UIControlStateNormal];
            NSString* metadata = @"";
            NSDictionary* metadataDict = [_player metadata];
            for (NSString* key in metadataDict.allKeys) {
                if (![key isEqualToString:@"picture"]) {
                    metadata = [metadata stringByAppendingFormat:@"%@: %@\n", key,
                                [metadataDict objectForKey:key]];
                }
            }
//            tvMetadata.text = metadata;
//            NSData* data = [metadataDict objectForKey:@"picture"];
//            ivCover.image = data ? [UIImage imageWithData:data] : nil;
//            [btnPause setTitle:NSLocalizedString(@"Pause", nil)
//                      forState:UIControlStateNormal];
//            [btnPlay setEnabled:NO];
            self.slider.maximumValue = _player.trackTime;
            break;
        }
//        case ORGMEngineStateError:
//            tvMetadata.text = [_player.currentError localizedDescription];
//            break;
    }
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

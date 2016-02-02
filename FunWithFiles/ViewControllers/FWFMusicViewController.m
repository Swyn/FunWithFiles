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
    self.title = [NSString stringWithFormat:@"%@", self.file.fileName];

    if (self.player != nil)
        [self.player removeObserver:self forKeyPath:@"status"];
    self.player = [[ORGMEngine alloc] init];
    self.player.delegate = self;
    [self.player addObserver:self forKeyPath:@"status" options:0 context:nil];
    
    NSString *urlString = [NSString stringWithFormat:@"http://ioschallenge.api.meetlima.com%@", self.file.path];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    self.url = [NSURL URLWithString:urlString];
    
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
        self.playedLabel.text = [NSString stringWithFormat:@"%@",
                              [self printSecond:self.player.amountPlayed]];
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
    }
    
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    [self.player seekToTime:self.slider.value];
}

- (void)engine:(ORGMEngine *)engine didChangeState:(ORGMEngineState)state {
    switch (state) {
        case ORGMEngineStatePaused: {
            [self.playButton setTitle:@"Play"
                      forState:UIControlStateNormal];
            break;
        }
        case ORGMEngineStatePlaying: {
            [self.playButton setTitle:@"Pause" forState:UIControlStateNormal];
            self.slider.maximumValue = _player.trackTime;
            self.toPlayLabel.text = [NSString stringWithFormat:@"%@", [self printSecond:self.player.trackTime]];
            break;
        }
    }
}

- (NSString *) printSecond:(NSInteger) seconds {
    
    if (seconds < 60) {
        return [NSString stringWithFormat:@"00:%02d", (int)seconds];
    }
    
    if (seconds >= 60) {
        
        int minutes = floor(seconds/60);
        int rseconds = trunc(seconds - minutes * 60);
        
        return [NSString stringWithFormat:@"%02d:%02d",minutes,rseconds];
        
    }
    
    return @"";
    
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

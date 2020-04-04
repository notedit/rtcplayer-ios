//
//  ViewController.m
//  rtcplayer-ios
//
//  Created by xiang on 2020/3/14.
//  Copyright © 2020 xiang. All rights reserved.
//

#import "ViewController.h"

#import <WebRTC/WebRTC.h>

#import "RTCLivePlayer.h"


@interface ViewController () <RTCLivePlayerDelegate>
{
    RTCLivePlayer* player;
    
}

@property (weak, nonatomic) IBOutlet UITextField *streamUrlInput;

@property (weak, nonatomic) IBOutlet UITextField *apiUrlInput;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.streamUrlInput.text = @"webrtc://localhost/live/live";
    self.apiUrlInput.text = @"http://172.20.10.10:1985/rtc/v1/play";
    
}



- (void)onPlayerState:(RTCLivePlayerState)playerState
{
    NSLog(@"onPlayerState change");
}

- (IBAction)play:(id)sender {
    
    
    player = [[RTCLivePlayer alloc] initWithDelegate:self];
    
    player.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width);
    
    [self.view addSubview:player.view];
    
    [player play:self.streamUrlInput.text];
}

@end

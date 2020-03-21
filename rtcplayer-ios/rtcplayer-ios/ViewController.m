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


static NSString* playUrl = @"webrtc://localhost/live/live";


@interface ViewController () <RTCLivePlayerDelegate>
{
    RTCLivePlayer* player;
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    player = [[RTCLivePlayer alloc] initWithDelegate:self];
    
    player.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width);
    
    [self.view addSubview:player.view];
    
    [player play:playUrl];
}



- (void)onPlayerState:(RTCLivePlayerState)playerState
{
    NSLog(@"onPlayerState change");
}


@end

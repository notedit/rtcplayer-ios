//
//  RTCLiveView.h
//  rtcplayer
//
//  Created by xiang on 2020/3/14.
//  Copyright © 2020 xiang. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <WebRTC/WebRTC.h>

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>


NS_ASSUME_NONNULL_BEGIN

@class RTCLiveView;

@protocol RTCLiveViewDelegate <NSObject>

- (void)videoViewDidReceiveData:(RTCLiveView *)renderer withSize:(CGSize)dimensions;
- (void)videoView:(RTCLiveView *)renderer streamDimensionsDidChange:(CGSize)dimensions;

@end



@interface RTCLiveView : NSObject

@property (nonatomic, readonly) CGSize videoSize;
@property (nonatomic, readonly) BOOL hasVideoData;
@property (nonatomic, weak)     id<RTCLiveViewDelegate>  dotViewDelegate;
@property (nonatomic, assign)   RTCLiveViewScaleMode scaleMode;
@property (nonatomic, assign)   BOOL mirror;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)setVideoTrack:(RTCVideoTrack*)track;



@end

NS_ASSUME_NONNULL_END

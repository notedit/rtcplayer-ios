//
//  RTCLivePlayer.h
//  rtcplayer
//
//  Created by xiang on 2020/3/14.
//  Copyright © 2020 xiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, RTCLiveViewScaleMode)
{
    RTCLiveViewScaleModeFit,    // 没有黑边，裁剪中间的部分来适配外部的view
    RTCLiveViewScaleModeFill,   // 会有黑边，视频全显示，直播模式下为默认选项
};


typedef NS_ENUM(NSInteger, RTCLivePlayerState)
{
    RTCLiveIdleState,       // 初始状态
    RTCLiveConnectingState,
    RTCLiveConnectedState,
    RTCLiveClosedState,
};



@protocol RTCLivePlayerDelegate <NSObject>

@optional
- (void)onPlayerState:(RTCLivePlayerState)playerState;

@end




@interface RTCLivePlayer : NSObject


//  渲染视图
@property (atomic,readonly) UIView* view;


// delegate
@property (nonatomic,weak) id<RTCLivePlayerDelegate> playerDelegate;


// 播放器状态
@property (atomic, readonly) RTCLivePlayerState state;


/// 实例化
- (instancetype) initWithDelegate:(id<RTCLivePlayerDelegate>)delegate;


// 开始直播
- (void) play:(NSString*)streamUrl;


// 停止
- (void) stop;


@end

NS_ASSUME_NONNULL_END

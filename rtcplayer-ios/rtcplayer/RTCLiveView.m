//
//  RTCLiveView.m
//  rtcplayer
//
//  Created by xiang on 2020/3/14.
//  Copyright © 2020 xiang. All rights reserved.
//

#import "RTCLiveView.h"

#import <WebRTC/WebRTC.h>


@interface RTCLiveView () <RTCVideoViewDelegate,RTCVideoRenderer>
{
    RTCEAGLVideoView *subview;
}


@property (nonatomic, weak)  RTCVideoTrack* track;
@property (nonatomic, assign) CGSize videoSize;
@property (nonatomic, assign) CGSize paraSize;


@end



@implementation RTCLiveView


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        subview = [[RTCEAGLVideoView alloc] init];
        subview.delegate = self;
        _videoSize.height = 100;
        _videoSize.width = 100;
        _scaleMode = RTCLiveViewScaleModeFit;
        self.opaque = NO;
        self.clipsToBounds = YES;
        [self addSubview:subview];
        self.backgroundColor = UIColor.blackColor;
    }
    
    return self;
}




-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat width = _videoSize.width, height = _videoSize.height;
    CGRect newValue;
    if (width <= 0 || height <= 0) {
        newValue.origin.x = 0;
        newValue.origin.y = 0;
        newValue.size.width = 0;
        newValue.size.height = 0;
    } else if (RTCLiveViewScaleModeFill == self.scaleMode) {
        newValue = self.bounds;
        if (newValue.size.width != width || newValue.size.height != height) {
            CGFloat scaleFactor
            = MAX(newValue.size.width / width, newValue.size.height / height);
            // Scale both width and height in order to make it obvious that the aspect
            // ratio is preserved.
            width *= scaleFactor;
            height *= scaleFactor;
            newValue.origin.x += (newValue.size.width - width) / 2.0;
            newValue.origin.y += (newValue.size.height - height) / 2.0;
            newValue.size.width = width;
            newValue.size.height = height;
        }
    } else { // contain
        newValue  = AVMakeRectWithAspectRatioInsideRect(CGSizeMake(width, height),
                                                        self.bounds);
    }
    
    CGRect oldValue = subview.frame;
    if (newValue.origin.x != oldValue.origin.x || newValue.origin.y != oldValue.origin.y
        || newValue.size.width != oldValue.size.width
        || newValue.size.height != oldValue.size.height) {
        
        subview.frame = newValue;
    }
    
}

-(void)setMirror:(BOOL)mirror
{
    if (_mirror != mirror) {
        _mirror = mirror;
        [self dispatchAsyncSetNeedsLayout];
    }
}


-(void)setScaleMode:(RTCLiveViewScaleMode)scaleMode
{
    if (_scaleMode != scaleMode) {
        _scaleMode = scaleMode;
        
        [self dispatchAsyncSetNeedsLayout];
    }
}

- (void)dispatchAsyncSetNeedsLayout {
    __weak UIView *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf setNeedsLayout];
    });
}


- (void) setVideoTrack:(RTCVideoTrack *)track
{
    
    RTCVideoTrack* oldValue = _track;
    
    if (oldValue != track) {
        if (oldValue != nil) {
            [oldValue removeRenderer:self];
        }
        
        _track = track;
        
        if (track != nil){
            [track addRenderer:self];
        }
    }
}


-(void)renderFrame:(RTCVideoFrame *)frame
{
    if(subview==nil){
        return;
    }
    [subview renderFrame:frame];
}



- (void)setSize:(CGSize)size {
    if (subview) {
        [subview setSize:size];
    }
}


- (void)videoView:(RTCEAGLVideoView *)videoView didChangeVideoSize:(CGSize)size {
    
    if (!_hasVideoData) {
        _hasVideoData = YES;
        
        if (_dotViewDelegate != nil) {
            [_dotViewDelegate videoViewDidReceiveData:self withSize:size];
        }
    }
    
    if (_dotViewDelegate != nil) {
        [_dotViewDelegate videoView:self streamDimensionsDidChange:size];
    }
    
    if (!CGSizeEqualToSize(_videoSize, size)) {
        _videoSize = size;
        [self dispatchAsyncSetNeedsLayout];
    }
}



@end

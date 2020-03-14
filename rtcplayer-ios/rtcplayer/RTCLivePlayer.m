//
//  RTCLivePlayer.m
//  rtcplayer
//
//  Created by xiang on 2020/3/14.
//  Copyright © 2020 xiang. All rights reserved.
//

#import "RTCLivePlayer.h"

#import <WebRTC/WebRTC.h>
#import <AFNetworking/AFNetworking.h>

#import "RTCLiveView.h"


@interface RTCLivePlayer () <RTCPeerConnectionDelegate,RTCRtpReceiverDelegate>
{
    
    RTCVideoDecoderFactoryH264* decoderFactory;
    RTCVideoEncoderFactoryH264* encoderFactory;
    
    RTCPeerConnection* connection;
    RTCPeerConnectionFactory* factory;
    
    RTCRtpTransceiver* audioTransceiver;
    RTCRtpTransceiver* videoTransceiver;
    RTCAudioTrack* audioTrack;
    RTCVideoTrack* videoTrack;
    
    AFHTTPSessionManager *sessionManager;
    
    RTCLiveView* renderView;

    
    NSString*  streamURL;
}



@end



@implementation RTCLivePlayer


-(instancetype) initWithDelegate:(id<RTCLivePlayerDelegate>)delegate
{
    
    self = [super init];
    
    
    _playerDelegate = delegate;
    _state = RTCLiveIdleState;
    
    [self p_initInternal];
    return self;

}



/// 设置渲染模式
- (void)setScaleMode:(RTCLiveViewScaleMode)scalemode
{
    
}


- (UIView*)view
{
    return renderView;
}


- (void) play:(NSString *)streamUrl
{
    
    streamURL = streamUrl;
    connection = [self p_createPeerConnection];
    connection.delegate = self;
    RTCRtpTransceiverInit* transceiverInit = [[RTCRtpTransceiverInit alloc] init];
    transceiverInit.direction = RTCRtpTransceiverDirectionRecvOnly;
    audioTransceiver = [connection addTransceiverOfType:RTCRtpMediaTypeAudio init:transceiverInit];
    videoTransceiver = [connection addTransceiverOfType:RTCRtpMediaTypeVideo init:transceiverInit];
    audioTransceiver.receiver.delegate = self;
    videoTransceiver.receiver.delegate = self;
    videoTrack = (RTCVideoTrack*)videoTransceiver.receiver.track;
    audioTrack = (RTCAudioTrack*)audioTransceiver.receiver.track;
    [videoTrack addRenderer:renderView];
    
    // handle sdp  
    
}


- (void) stop
{
    // todo
}


- (void)p_initInternal
{
    
    // http session
    sessionManager = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    sessionManager.requestSerializer = requestSerializer;
    
    RTCInitializeSSL();
    
    
    renderView = [[RTCLiveView alloc] initWithFrame:CGRectZero];
    
    decoderFactory = [[RTCVideoDecoderFactoryH264 alloc] init];
    encoderFactory = [[RTCVideoEncoderFactoryH264 alloc] init];
    
    // factory
    factory = [[RTCPeerConnectionFactory alloc] initWithEncoderFactory:encoderFactory decoderFactory:decoderFactory];
    
}


- (RTCPeerConnection*)p_createPeerConnection
{
    RTCConfiguration *config = [[RTCConfiguration alloc] init];
    config.bundlePolicy = RTCBundlePolicyMaxBundle;
    config.rtcpMuxPolicy = RTCRtcpMuxPolicyRequire;
    config.iceTransportPolicy = RTCIceTransportPolicyAll;
    config.sdpSemantics = RTCSdpSemanticsUnifiedPlan;
    config.tcpCandidatePolicy = RTCTcpCandidatePolicyEnabled;
    config.iceCandidatePoolSize = 1;
    
    RTCPeerConnection* peerconnection = [factory peerConnectionWithConfiguration:config
                                                                     constraints:nil
                                                                        delegate:nil];
    return peerconnection;
}






- (NSString*)p_peerConnectionState:(RTCPeerConnectionState)newState
{
    NSString* state;
    switch (newState) {
        case RTCPeerConnectionStateNew:
            state = @"RTCPeerConnectionStateNew";
            break;
        case RTCPeerConnectionStateConnecting:
            state = @"RTCPeerConnectionStateConnecting";
            break;
        case RTCPeerConnectionStateConnected:
            state = @"RTCPeerConnectionStateConnected";
            break;
        case RTCPeerConnectionStateDisconnected:
            state = @"RTCPeerConnectionStateDisconnected";
            break;
        case RTCPeerConnectionStateFailed:
            state = @"RTCPeerConnectionStateFailed";
            break;
        case RTCPeerConnectionStateClosed:
            state = @"RTCPeerConnectionStateClosed";
            break;
        default:
            state = @"";
            break;
    }
    return state;
}

#pragma RTCPeerConnectionDelegate

- (void)peerConnection:(RTCPeerConnection *)peerConnection
didChangeSignalingState:(RTCSignalingState)stateChanged
{
    
}

/** Called when media is received on a new stream from remote peer. */
- (void)peerConnection:(RTCPeerConnection *)peerConnection didAddStream:(RTCMediaStream *)stream
{
    
}

/** Called when a remote peer closes a stream.
 *  This is not called when RTCSdpSemanticsUnifiedPlan is specified.
 */
- (void)peerConnection:(RTCPeerConnection *)peerConnection didRemoveStream:(RTCMediaStream *)stream
{
    
}

/** Called when negotiation is needed, for example ICE has restarted. */
- (void)peerConnectionShouldNegotiate:(RTCPeerConnection *)peerConnection
{
    
}

/** Called any time the IceConnectionState changes. */
- (void)peerConnection:(RTCPeerConnection *)peerConnection
didChangeIceConnectionState:(RTCIceConnectionState)newState
{
    
}

/** Called any time the IceGatheringState changes. */
- (void)peerConnection:(RTCPeerConnection *)peerConnection
didChangeIceGatheringState:(RTCIceGatheringState)newState
{
    
}

/** New ice candidate has been found. */
- (void)peerConnection:(RTCPeerConnection *)peerConnection
didGenerateIceCandidate:(RTCIceCandidate *)candidate
{
    
}

/** Called when a group of local Ice candidates have been removed. */
- (void)peerConnection:(RTCPeerConnection *)peerConnection
didRemoveIceCandidates:(NSArray<RTCIceCandidate *> *)candidates
{
    
}

/** New data channel has been opened. */
- (void)peerConnection:(RTCPeerConnection *)peerConnection
    didOpenDataChannel:(RTCDataChannel *)dataChannel
{
    
}

/** Called any time the IceConnectionState changes following standardized
 * transition. */
- (void)peerConnection:(RTCPeerConnection *)peerConnection
didChangeStandardizedIceConnectionState:(RTCIceConnectionState)newState
{
    
}

/** Called any time the PeerConnectionState changes. */
- (void)peerConnection:(RTCPeerConnection *)peerConnection
didChangeConnectionState:(RTCPeerConnectionState)newState
{
    
    NSString* state = [self p_peerConnectionState:newState];
    NSLog(@"peerconnection state %@", state);
}

- (void)peerConnection:(RTCPeerConnection *)peerConnection
didStartReceivingOnTransceiver:(RTCRtpTransceiver *)transceiver
{
    
    NSLog(@"startReceiving %@", transceiver.receiver.receiverId);
}

/** Called when a receiver and its track are created. */
- (void)peerConnection:(RTCPeerConnection *)peerConnection
        didAddReceiver:(RTCRtpReceiver *)rtpReceiver
               streams:(NSArray<RTCMediaStream *> *)mediaStreams
{
    
    if ([rtpReceiver.track.kind isEqualToString:@"video"]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //[renderView setVideoTrack:(RTCVideoTrack*)rtpReceiver.track];
        });
    }
    
    if ([rtpReceiver.track.kind isEqualToString:@"audio"]){
        NSLog(@"Receiver %@", audioTransceiver.receiver.receiverId);
        NSLog(@"Receiver %@", rtpReceiver.receiverId);
    }
}

/** Called when the receiver and its track are removed. */
- (void)peerConnection:(RTCPeerConnection *)peerConnection
     didRemoveReceiver:(RTCRtpReceiver *)rtpReceiver
{
    
    NSLog(@"RemoveReceiver %@", rtpReceiver.receiverId);
    
    if ([rtpReceiver.track.kind isEqualToString:@"video"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [renderView setVideoTrack:nil];
        });
    }
}

/** Called when the selected ICE candidate pair is changed. */
- (void)peerConnection:(RTCPeerConnection *)peerConnection
didChangeLocalCandidate:(RTCIceCandidate *)local
       remoteCandidate:(RTCIceCandidate *)remote
        lastReceivedMs:(int)lastDataReceivedMs
          changeReason:(NSString *)reason
{
    NSLog(@"didChangeLocalCandidate %@", reason);
}




#pragma RTCRtpReceiverDelegate

- (void)rtpReceiver:(RTCRtpReceiver *)rtpReceiver
didReceiveFirstPacketForMediaType:(RTCRtpMediaType)mediaType
{
    
    NSLog(@"first packet");
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
}


@end

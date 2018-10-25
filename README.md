pod "webRTCHelper"


WebRTC的基础知识和实现原理可以参考这篇文章，[ios下音视频通信的实现-基于WebRTC](http://www.cocoachina.com/ios/20170306/18837.html)。

上述文章里面也有介绍到WebRTC在ios下的环境搭建，这里介绍一个利用Pod导入的方法。[WebRTC官网](https://webrtc.org/native-code/ios/)上有说到。

先附上本人自己写的demo下载地址，参照demo，会对这篇文章有更好的理解。[WebRTCdemo地址](https://github.com/wode0weiyi/WebRTC_demo)

`捷径：下面三步，现在可以一步就可以完成，就是直接在Podfile文件里面pod WebRTCHelper就可以了。这个WebRTCHelper是我传到pod上面的，只作参考`
> source 'https://github.com/CocoaPods/Specs.git'
target 'WebRTCHelper_pod' do
  platform :ios, '9.0'
  pod 'WebRTCHelper'
end

终端进入到项目文件夹中，输入：
> pod install

运行结果如图：下面三个步骤要导入的工程，全部都pod进项目中了。
![pod webRTCHelper](https://upload-images.jianshu.io/upload_images/5447877-c2bfdfbd47192800.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/500)




####第一步：在你的Podfile文件里面加入下面这段代码
```
source 'https://github.com/CocoaPods/Specs.git'
target 'YOUR_APPLICATION_TARGET_NAME_HERE' do
  platform :ios, '9.0'
  pod 'GoogleWebRTC'
end
```
`GoogleWebRTC `就是WebRTC的ios版本frameWork。

####第二步：导入需要用到的WebSocket库；在Podfile文件里面加入
> pod 'SocketRocket'

####第三步：创建WebRTC的管理类，命名为WebRTCHelper，继承NSObject，这个网上都有，我这里提供了一个[WebRTCHelper](https://github.com/wode0weiyi/WebRTCHelper)


完成上面的步骤，基本的工作就做完了，接下来就是测试了。如果是局域网里面测试，我们可以用到前面推荐阅读的[那篇文章](http://www.cocoachina.com/ios/20170306/18837.html)快到底的地方有个关于说服务器端WebSocket搭建的，有直接给你写好的服务器，只需要简单的操作就可以完成测试服务的搭建。这里就不多阐述。

现在在网络上还有其他的集成方式主要是自己编译WebRTC的源码，然后拉入到自己的项目中，添加依赖库，这个方式比较繁琐，在编译的时候会出现各种问题。既然官方有提供这个pod的库，直接pod是最简单的。

-----

####第二部分
WebRTC环境搭建就是这样了！下面具体讲解下WebRTCHelper管理类里面的具体方法和代理：
######WebRTCHelper.h文件
* 1-1.声明一个单例
```
+(instancetype)shareInstance;
```
* 1-2 声明四个public方法
```
/**
 * 与服务器建立连接
 * @param server 服务器地址
 * @param port 端口号
 * @param room 房间号
 */
-(void)connectServer:(NSString *)server port:(NSString *)port room:(NSString *)room;
/**
 * 切换摄像头
 */
-(void)swichCamera;
/**
 * 是否显示本地视频
 */
-(void)showLocaolCamera;
/**
 * 退出房间
 */
-(void)exitRoom;
```
*  1-3 声明两个代理
```
/*注释*/
@property (nonatomic,weak) id<WebRTCHelperDelegate> delegate;
/*注释*/
@property (nonatomic,weak) id<WebRTCHelperFrindDelegate> friendDelegate;
```
`WebRTCHelperDelegate`代理方法：
```
/**
 * 获取到发送信令消息
 * @param webRTCHelper 本类
 * @param message 消息内容
 */
-(void)webRTCHelper:(WebRTCHelper *)webRTCHelper receiveMessage:(NSString *)message;
/**
 * 获取本地的localVideoStream数据（旧版本返回localStream方法）
 * @param webRTCHelper 本类
 * @param steam 视频流
 * @param userId 用户标识
 */
-(void)webRTCHelper:(WebRTCHelper *)webRTCHelper setLocalStream:(RTCMediaStream *)steam userId:(NSString *)userId;
/**
 * 获取远程的remoteVideoStream数据
 * @param webRTCHelper 本类
 * @param stream 视频流
 * @param userId 用户标识
 */
-(void)webRTCHelper:(WebRTCHelper *)webRTCHelper addRemoteStream:(RTCMediaStream *)stream userId:(NSString *)userId;
/**
 * 某个用户退出后，关闭用户的连接
 * @param webRTCHelper 本类
 * @param userId 用户标识
 */
- (void)webRTCHelper:(WebRTCHelper *)webRTCHelper closeWithUserId:(NSString *)userId;

/**
 * 获取socket连接状态
 * @param webRTCHelper 本类
 * @param connectState 连接状态，分为
 WebSocketConnectSuccess 成功,
 WebSocketConnectField, 失败
 WebSocketConnectClosed 关闭
 */
-(void)webRTCHelper:(WebRTCHelper *)webRTCHelper socketConnectState:(WebSocketConnectState)connectState;
/**
 * 获取本地视频流的AVCaptureSession（新版本实现本地视频展示代理）
 * @param webRTCHelper
 * @param captureSession AVCaptureSession类
 */
-(void)webRTCHelper:(WebRTCHelper *)webRTCHelper capturerSession:(AVCaptureSession *)captureSession;
```
`WebRTCHelperFrindDelegate`代理方法，这个代理方法是做房间用户列表所用：
```
/**
 * 获取房间内所有的用户（除了自己）
 * @param friendList 用户列表
 */
-(void)webRTCHelper:(WebRTCHelper *)webRTCHelper gotFriendList:(NSArray *)friendList;
/**
 * 获取新加入的用户信息
 * @param friendId 新用户的id
 */
-(void)webRTCHelper:(WebRTCHelper *)webRTCHelper gotNewFriend:(NSString *)friendId;
/**
 * 获取离开房间用户的信息
 * @param friendId 离开用户的ID
 */
-(void)webRTCHelper:(WebRTCHelper *)webRTCHelper removeFriend:(NSString *)friendId;
```

######WebRTCHelper.m文件 
.m里面的方法实现就按照整体的实现流程来说明：
* 1、先与服务器建立起socket连接，这里要借助SRWebSocket库，见方法
```
/**
 * 与服务器进行连接
 */
- (void)connectServer:(NSString *)server port:(NSString *)port room:(NSString *)room{
    _server = server;
    _room = room;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"ws://%@:%@",server,port]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
    _socket = [[SRWebSocket alloc] initWithURLRequest:request];
    _socket.delegate = self;
    [_socket open];
}
```
* 2、在与服务器建立连接之后，会调用SRWebSocket的代理，见代码
```
/**
 * webSocket连接成功
 */
- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    NSLog(@"socket连接成功");
    [self joinRoom:_room];
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self->_delegate respondsToSelector:@selector(webRTCHelper:socketConnectState:)]) {
            [self->_delegate webRTCHelper:self socketConnectState:WebSocketConnectSuccess];
        }
    });
}
/**
 * webSocket连接失败，返回失败原因
 */
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    NSLog(@"socket连接失败");
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self->_delegate respondsToSelector:@selector(webRTCHelper:socketConnectState:)]) {
            [self->_delegate webRTCHelper:self socketConnectState:WebSocketConnectSuccess];
        }
    });
}
/**
 * webSocket关闭连接，返回关闭的原因reason
 */
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    NSLog(@"socket关闭。code = %ld,reason = %@",code,reason);
}
```
* 3、在SRWebSocket的连接成功的代理里做加入房间操作，2步骤处有调用，加入房间就是socket发送一个`__join`的信令，现在看下加入房间里面的代码实现：
```
/**
 *  加入房间
 *
 *  @param room 房间号
 */
- (void)joinRoom:(NSString *)room
{
    //如果socket是打开状态
    if (_socket.readyState == SR_OPEN)
    {
        //初始化加入房间的类型参数 room房间号
        NSDictionary *dic = @{@"eventName": @"__join", @"data": @{@"room": room}};
        
        //得到json的data
        NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        //发送加入房间的数据
        [_socket send:data];
    }
}
```
* 4、调用加入房间`joinRoom:`时，会发送`__join`信令到服务器，此时如果房间内有其他的用户，就会返回信令`__peers`，告诉你房间内有用户，需要建立连接，这个接收`__Peers`信令方法就是SRWebSocket的接收消息代理方法`webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message`
* 5、在方法`webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message`里面的`eventName==@"__peers"`条件下，做以下操作：
-- 5-1 对房间内其他的所有用户建立RTCPeerConnction连接`[self createPeerConnections];`
-- 5-2 对建立的所有连接添加本地视频流`[self addStreams];`
-- 5-3 发送本地的offer给到房间内所有的用户`[self createOffers];`
这些操作完成后就可以和房间内其他人建立起视频聊天了；如果房间内没有其他用户的话，就不需要做多余的操作。
* 6、针对房间内其他用户的加入，会在`webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message`方法里面收到`_new_peer`信令，这个时候要针对这个用户创建一个`RTCPeerConnection`连接，然后给这个链接添加本地视频流，然后设置代理回调；
-- 6-1、新加入的用户，会发送ice候选地址，就是通过ICEService服务器获取的地址，在`webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message`方法里面的`eventName`为`_ice_candidate`条件下有代码和说明；
-- 6-2、先加入的用户还会发送本身的offer，也就是remote的sdp描述。在接收到新加入用户发的offer的时候，会获取到这个先加入用户的连接`peerConnection`，然后发送sdp描述对象；这个代码是在`webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message`方法里面的`eventName`为`_offer`的条件下。

---
注意的地方：
---
这这里需要注意一个方面就是针对最新库和比较旧的库之间在`创建本地视频流`和`创建视频约束`的时候不一样的地方；
* 创建本地视频流，在WebRTCHelper.m文件的`createLocalStream`方法里面的`if(device){}`条件下
-- 最新版的库创建本地视频流的方法
```
//创建RTCVideoSource
RTCVideoSource *videoSource = [_factory videoSource];
//创建RTCCameraVideoCapturer
RTCCameraVideoCapturer * capture = [[RTCCameraVideoCapturer alloc] initWithDelegate:videoSource];
//创建AVCaptureDeviceFormat
AVCaptureDeviceFormat * format = [[RTCCameraVideoCapturer supportedFormatsForDevice:device] lastObject];   
//获取设备的fbs
CGFloat fps = [[format videoSupportedFrameRateRanges] firstObject].maxFrameRate;
//创建RTCVideoTrack
RTCVideoTrack *videoTrack = [_factory videoTrackWithSource:videoSource trackId:@"ARDAMSv0"];
__weak RTCCameraVideoCapturer *weakCapture = capture;
__weak RTCMediaStream * weakStream = _localStream;
__weak NSString * weakMyId = _myId;
//捕获摄像头的视频数据
[weakCapture startCaptureWithDevice:device format:format fps:fps completionHandler:^(NSError * error) {
      NSLog(@"11111111");
      [weakStream addVideoTrack:videoTrack];
      if ([self->_delegate respondsToSelector:@selector(webRTCHelper:setLocalStream:userId:)])
     {
  //在实现代理中，将weakCapture.captureSession设置到RTCCameraPreviewView的captureSession属性，视频才能显示
         [self->_delegate webRTCHelper:self capturerSession:weakCapture.captureSession];
       }
}];
```
* 旧版库创建本视频流的方法
```
 /*旧版本创建videoSource是RTCAVFoundationVideoSource类，新版是RTCVideoSource，且创建的方法也不一样*/
RTCAVFoundationVideoSource *videoSource = [_factory avFoundationVideoSourceWithConstraints:[self localVideoConstraints]];
//创建RTCVideoTrack,这个方法没有什么变化
RTCVideoTrack *videoTrack = [_factory videoTrackWithSource:videoSource trackId:@"ARDAMSv0"];
//本地流添加RTCVideoTrack
[_localStream addVideoTrack:videoTrack];
//代理回调
 if ([self->_delegate respondsToSelector:@selector(webRTCHelper:setLocalStream:userId:)])
     {
  //将localStream中的videoTracks数据绑定到RTCEAGLVideoView类型localVideoView上，本地视频才会显示
         [self->_delegate webRTCHelper:self setLocalStream:weakStream userId:weakMyId];  
     }
```
----
WebRTCHelper.m文件里面就这么多主要的实现；然后看具体怎么去调用这些功能实现音视频通话。

####第一、先定义以下的属性
```
/*保存远端视频流*/
@property (nonatomic,strong) NSMutableDictionary *videoTracks;
/*房间内其他用户*/
@property (nonatomic,strong) NSMutableArray *members;
//显示本地视频的view
@property (weak, nonatomic) IBOutlet RTCCameraPreviewView *localVideoView;
```
`localVideView`在最新库下，是`RTCCameraPreviewView `类型，如果是旧版本的话，是`RTCEAGLVideoView`类型

然后在`viewDidLoad`设置WebRTCHelper的代理为self
```
[WebRTCHelper shareInstance].delegate = self;
 [WebRTCHelper shareInstance].friendDelegate = self;
```
创建连接，连接到socket服务器上面
`viewDidLoad`
```
[self connect];
```
```
/**
 * 连接服务器
 */
-(void)connect{
//    [[WebRTCHelper shareInstance] connectServer:@"192.168.30.186" port:@"3000" room:@"100"];
    [[WebRTCHelper shareInstance] connectServer:@"115.236.101.203" port:@"18080" room:@"100"];
}
```
连接服务成功后，会在`WebRTCHelper`里面的socket代理里面调用`joinRoom`方法，然后会在`WebRTCHelperDelegate`和`WebRTCHelperFrindDelegate`代理里面去获取数据，这里具体说下获取视频流的两个代理方法。

第一个代理方法是获取本地视频流的方法：
* 旧版库本地代理获取方法：
```
/**
 * 旧版本获取本地视频流的代理，在这个代理里面会获取到RTCVideoTrack类，然后添加到RTCEAGLVideoView类型的localVideoView上面
 */
- (void)webRTCHelper:(WebRTCHelper *)webRTCHelper setLocalStream:(RTCMediaStream *)steam userId:(NSString *)userId{
    if (steam) {
        _localSteam = steam;
        RTCVideoTrack * track = [_localSteam.videoTracks lastObject];
        [track addRenderer:self.localVideoView];
    }
    
}
```
上面这个获取本地视频流的代理方法只针对旧版本才可以，注意当中的`localVideoView`是`RTCEAGLVideoView `类型的

* 新版库获取本地视频流的方法
-- 这个方式主要是获取到`RTCCameraPreviewView `的`AVCaptureSession `类型的属性数据
```
/**
 * 新版获取本地视频流的方法
 * @param captureSession RTCCameraPreviewView类的参数，通过设置这个，就可以达到显示本地视频的功能
 */
- (void)webRTCHelper:(WebRTCHelper *)webRTCHelper capturerSession:(AVCaptureSession *)captureSession{
    self.localVideoView.captureSession = captureSession;
}
```

第二就是获取远端视频流的方法：
```
/**
 * 获取远端视频流的方法，主要是获取到RTCVideoTrack类型的数据，然后保存起来，在刷新列表的时候，添加到对应item里面的RTCEAGLVideoView类型的view上面
 */
- (void)webRTCHelper:(WebRTCHelper *)webRTCHelper addRemoteStream:(RTCMediaStream *)stream userId:(NSString *)userId{
    RTCVideoTrack * track = [stream.videoTracks lastObject];
    if (track != nil) {
        [self.videoTracks setObject:track forKey:userId];
    }
        [self.collectionView reloadData];
}
```

---
---
主要的实现都在这里了，肯定是有不到位的地方，还希望浏览有心人士帮忙指出，共同进步。

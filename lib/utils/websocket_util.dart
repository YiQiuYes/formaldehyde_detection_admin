import 'dart:async';

import 'package:formaldehyde_detection/state/global_logic.dart';
import 'package:formaldehyde_detection/utils/logger_util.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

const String _socketUrl = 'ws://192.168.123.150:8080/websocket';

/// WebSocket状态
enum SocketStatus {
  socketStatusConnected, // 已连接
  socketStatusFailed, // 失败
  socketStatusClosed, // 连接关闭
}

class WebSocketUtil {
  WebSocketUtil._privateConstructor();

  static final WebSocketUtil _instance = WebSocketUtil._privateConstructor();

  factory WebSocketUtil() {
    return _instance;
  }

  IOWebSocketChannel? _webSocket; // WebSocket
  SocketStatus? _socketStatus; // socket状态
  Timer? _heartBeat; // 心跳定时器
  final int _heartTimes = 3000; // 心跳间隔(毫秒)
  final int _reconnectCount = 60; // 重连次数，默认60次
  int _reconnectTimes = 0; // 重连计数器
  Timer? _reconnectTimer; // 重连定时器
  Function? onError; // 连接错误回调
  Function? onOpen; // 连接开启回调
  Function? onMessage; // 接收消息回调

  /// 初始化WebSocket
  void initWebSocket({
    Function? onOpen,
    Function? onMessage,
    Function? onError,
  }) {
    this.onOpen = onOpen;
    this.onMessage = onMessage;
    this.onError = onError;
    openSocket();
  }

  /// 开启WebSocket连接
  void openSocket() {
    closeSocket();
    final globalLogic = Get.find<GlobalLogic>();
    String? token = globalLogic.getToken();
    _webSocket = IOWebSocketChannel.connect("$_socketUrl?token=$token");
    LoggerUtil.i('WebSocket连接成功: $_socketUrl?token=$token');
    // 连接成功，返回WebSocket实例
    _socketStatus = SocketStatus.socketStatusConnected;
    // 连接成功，重置重连计数器
    _reconnectTimes = 0;
    if (_reconnectTimer != null) {
      _reconnectTimer?.cancel();
      _reconnectTimer = null;
    }
    if (onOpen != null) {
      onOpen!();
    }
    // 接收消息
    _webSocket?.stream.listen(
      (data) => webSocketOnMessage(data),
      onError: webSocketOnError,
      onDone: webSocketOnDone,
    );
  }

  /// WebSocket接收消息回调
  webSocketOnMessage(data) {
    if (onMessage != null) {
      onMessage!(data);
    }
  }

  /// WebSocket关闭连接回调
  webSocketOnDone() {
    LoggerUtil.i('closed');
    reconnect();
  }

  /// WebSocket连接错误回调
  webSocketOnError(e) {
    WebSocketChannelException ex = e;
    _socketStatus = SocketStatus.socketStatusFailed;
    if (onError != null) {
      onError!(ex.message);
    }
    closeSocket();
  }

  /// 初始化心跳
  void initHeartBeat() {
    destroyHeartBeat();
    _heartBeat = Timer.periodic(Duration(milliseconds: _heartTimes), (timer) {
      sentHeart();
    });
  }

  /// 心跳
  void sentHeart() {
    // sendMessage('{"module": "HEART_CHECK", "message": "请求心跳"}');
  }

  /// 销毁心跳
  void destroyHeartBeat() {
    if (_heartBeat != null) {
      _heartBeat?.cancel();
      _heartBeat = null;
    }
  }

  /// 关闭WebSocket
  void closeSocket() {
    if (_webSocket != null) {
      LoggerUtil.i('WebSocket连接关闭');
      _webSocket?.sink.close();
      destroyHeartBeat();
      _socketStatus = SocketStatus.socketStatusClosed;
    }
  }

  /// 发送WebSocket消息
  void sendMessage(message) {
    if (_webSocket != null) {
      switch (_socketStatus) {
        case SocketStatus.socketStatusConnected:
          LoggerUtil.i('发送中：$message');
          _webSocket?.sink.add(message);
          break;
        case SocketStatus.socketStatusClosed:
          LoggerUtil.i('连接已关闭');
          break;
        case SocketStatus.socketStatusFailed:
          LoggerUtil.e('发送失败');
          break;
        default:
          break;
      }
    }
  }

  /// 重连机制
  void reconnect() {
    if (_reconnectTimes < _reconnectCount) {
      _reconnectTimes++;
      _reconnectTimer = Timer.periodic(Duration(milliseconds: _heartTimes), (
        timer,
      ) {
        openSocket();
      });
    } else {
      if (_reconnectTimer != null) {
        LoggerUtil.e('重连次数超过最大次数');
        _reconnectTimer?.cancel();
        _reconnectTimer = null;
      }
      return;
    }
  }
}

import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

typedef Future<dynamic> MessageHandler(Map<String, dynamic> message);
typedef Future<dynamic> TokenHandler(String token);

class AzureNotificationHubFlutter {
  static const MethodChannel _channel =
      const MethodChannel('azure_notification_hub_flutter');

  late MessageHandler _onMessage;
  late MessageHandler _onResume;
  late MessageHandler _onLaunch;
  late TokenHandler _onToken;

  /// Sets up [MessageHandler] for incoming messages.
  void configure(
      {MessageHandler? onMessage,
      MessageHandler? onResume,
      MessageHandler? onLaunch,
      TokenHandler? onToken}) {
    _onMessage = onMessage!;
    _onLaunch = onLaunch!;
    _onResume = onResume!;
    _onToken = onToken!;
    _channel.setMethodCallHandler(_handleMethod);
    _channel.invokeMethod<void>('configure');
  }

  //add a function that calls the native AddTag method
  Future<void> addTag(String tag) async {
    await _channel.invokeMethod<void>('addTag', tag);
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case "onToken":
        return _onToken(call.arguments);
      case "onMessage":
        if (Platform.isAndroid) {
          Map<String, dynamic> args = Map<String, dynamic>.from(call.arguments);
          return _onMessage(Map<String, dynamic>.from(args['data']));
        }
        return _onMessage(call.arguments.cast<String, dynamic>());
      case "onLaunch":
        if (Platform.isAndroid) {
          Map<String, dynamic> args = Map<String, dynamic>.from(call.arguments);
          return _onMessage(Map<String, dynamic>.from(args['data']));
        }
        return _onLaunch(call.arguments.cast<String, dynamic>());
      case "onResume":
        if (Platform.isAndroid) {
          Map<String, dynamic> args = Map<String, dynamic>.from(call.arguments);
          return _onMessage(Map<String, dynamic>.from(args['data']));
        }
        return _onResume(call.arguments.cast<String, dynamic>());
      default:
        throw UnsupportedError("Unrecognized JSON message");
    }
  }
}

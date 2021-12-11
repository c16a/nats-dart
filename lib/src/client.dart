import 'dart:typed_data';
import 'package:nats/nats.dart';
import 'package:nats/src/buffer.dart';
import 'package:nats/src/protocol_sender.dart';
import 'dart:io';
import 'dart:async';

import 'package:nats/src/typedefs.dart';

class NatsClient {
  List<String> servers;
  ConnectionOpts? opts;

  Socket? _currentSocket;
  ProtocolSender? _sender;
  MessageHandler? _messageHandler;

  int currentServerIndex = 0;

  NatsClient({required this.servers, this.opts});

  Future<void> connect() async {
    await connectToServer(currentServerIndex);
  }

  Future<void> connectToServer(int index) async {
    var uri = Uri.parse(servers[index]);
    _currentSocket = await Socket.connect(uri.host, uri.port);
    _startSocketListener();
    _startSocketSender();
  }

  void setMessageHandler(MessageHandler messageHandler) {
    _messageHandler = messageHandler;
  }

  void _startSocketListener() {
    _currentSocket?.listen(
      _dataHandler,
      onError: (error) {
        _handleServerConnectionError();
      },
      onDone: () {
        _handleServerGoneError();
      },
    );
  }

  void _startSocketSender() {
    _sender = ProtocolSender(socket: _currentSocket);
  }

  void _dataHandler(Uint8List data) {
    final serverResponse = String.fromCharCodes(data);

    var firstWord = serverResponse.split(" ")[0];
    switch (firstWord) {
      case "MSG":
        var message = NatsMessage(serverResponse);
        _messageHandler?.call(message);
    }
  }

  Future<void> _handleServerConnectionError() async {
    _cycleToNextServer();
    await connectToServer(currentServerIndex);
  }

  Future<void> _handleServerGoneError() async {
    _cycleToNextServer();
    await connectToServer(currentServerIndex);
  }

  void _cycleToNextServer() {
    currentServerIndex =
        currentServerIndex < servers.length - 1 ? currentServerIndex + 1 : 0;
  }

  /// Publishes a new message to the NATS server
  ///
  /// Requires the [subject] and [data] parameters,
  /// and optionally a [replySubject] to receive the replies on.
  void publish({
    required String subject,
    String? replySubject,
    required String data,
  }) =>
      _sender?.sendPublish(subject, replySubject, data, null);

  String? subscribe(
          {required String subject,
          String? queueGroup,
          CompletionHandler? completionHandler}) =>
      _sender?.sendSubscribe(subject, queueGroup, completionHandler);

  void unsubscribe(
          {required String sid,
          int? waitUntilMessages,
          CompletionHandler? completionHandler}) =>
      _sender?.sendUnsubscribe(sid, waitUntilMessages, completionHandler);
}

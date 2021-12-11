import 'dart:io';
import 'package:logging/logging.dart';
import 'package:nats/src/buffer.dart';
import 'package:nats/src/typedefs.dart';

class ProtocolSender {
  final Socket? socket;
  final Logger? logger;

  ProtocolSender({this.socket, this.logger});

  // Publish packets
  void sendPublish(String subject, String? replySubject, String data,
      CompletionHandler? completionHandler) {
    var messageBuffer =
        MessageBuffers.publishPacket(subject, data, replySubject);
    socket?.write(messageBuffer);
    completionHandler?.call();
  }

  String sendSubscribe(
      String subject, String? queueGroup, CompletionHandler? doneHandler) {
    var tuple = MessageBuffers.subscribePacket(subject, queueGroup);
    var cmd = tuple.item1;
    var sid = tuple.item2;
    socket?.write(cmd);
    doneHandler?.call();
    return sid;
  }

  void sendUnsubscribe(
      String sid, int? waitUntilMessages, CompletionHandler? doneHandler) {
    var messageBuffer =
        MessageBuffers.unsubscribePacket(sid, waitUntilMessages);
    socket?.write(messageBuffer);
    doneHandler?.call();
  }
}

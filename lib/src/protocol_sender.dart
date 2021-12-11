import 'dart:io';
import 'package:nats/src/buffer.dart';
import 'package:nats/src/typedefs.dart';
import 'package:uuid/uuid.dart';

class ProtocolSender {
  final Socket? socket;

  ProtocolSender(this.socket);

  // Publish packets
  void sendPublish(String subject, String? replySubject, String data,
      CompletionHandler? completionHandler) {
    var messageBuffer =
        MessageBuffers.publishPacket(subject, data, replySubject);
    socket?.write(messageBuffer);
    completionHandler?.call();
  }

  String sendSubscribe(String subject, String? queueGroup) {
    var uuid = Uuid();
    var sid = uuid.v4();

    var messageBuffer =
        MessageBuffers.subscribePacket(subject, queueGroup, sid);
    socket?.write(messageBuffer);
    return sid;
  }

  void sendUnsubscribe(String sid, int? waitUntilMessages) {
    var messageBuffer =
        MessageBuffers.unsubscribePacket(sid, waitUntilMessages);
    socket?.write(messageBuffer);
  }
}

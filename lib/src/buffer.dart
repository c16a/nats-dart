import 'package:nats/nats.dart';
import 'package:uuid/uuid.dart';
import 'package:tuple/tuple.dart';

import "dart:convert";

class MessageBuffers {
  // CONNECT {["option_name":option_value],...}
  static String connectPacket(ConnectionOpts opts) {
    var messageBuffer = "CONNECT ${jsonEncode(opts)}\r\n";
    return messageBuffer;
  }

  // PUB <subject> [reply-to] <#bytes>\r\n[payload]
  static String publishPacket(
      String subject, String data, String? replySubject) {
    String messageBuffer;

    int length = data.length;

    if (replySubject != null) {
      messageBuffer = "PUB $subject $replySubject $length \r\n$data\r\n";
    } else {
      messageBuffer = "PUB $subject $length \r\n$data\r\n";
    }

    return messageBuffer;
  }

  // SUB <subject> [queue group] <sid>
  static Tuple2<String, String> subscribePacket(
      String subject, String? queueGroup) {
    String messageBuffer;

    var uuid = Uuid();
    var sid = uuid.v4();

    if (queueGroup != null) {
      messageBuffer = "SUB $subject $queueGroup $sid\r\n";
    } else {
      messageBuffer = "SUB $subject $sid\r\n";
    }

    return Tuple2(messageBuffer, sid);
  }

  // UNSUB <sid> [max_msgs]
  static String unsubscribePacket(String sid, int? waitUntilMessages) {
    String messageBuffer;

    if (waitUntilMessages != null) {
      messageBuffer = "UNSUB $sid $waitUntilMessages\r\n";
    } else {
      messageBuffer = "UNSUB $sid\r\n";
    }

    return messageBuffer;
  }

  // PING
  static String pingPacket() {
    String messageBuffer;
    messageBuffer = "PING\r\n";
    return messageBuffer;
  }

  // PONG
  static String pongPacket() {
    String messageBuffer;
    messageBuffer = "PONG\r\n";
    return messageBuffer;
  }
}

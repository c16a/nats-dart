class NatsMessage {
  late final String payload;
  late final String subject;
  late final String sid;
  late final int length;
  String? replyTo;

  NatsMessage(String protocolMessage) {
    var lines = protocolMessage.split("\r\n");

    var protocolInfo = lines[0];
    payload = lines.length == 1 ? "" : lines[1];

    var parts = protocolInfo.split(" ");
    subject = parts[1];
    sid = parts[2];

    // Reply-To is optional
    replyTo = parts.length == 5 ? parts[3] : null;

    // Last item is always length
    length = int.parse(parts[parts.length - 1]);
  }
}

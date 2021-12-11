import 'package:nats/nats.dart';

void main() async {
  var client = NatsClient(servers: ["nats://localhost:4222"], opts: null);
  await client.connect();

  client.setMessageHandler((message) {
    print("Received message ${message.payload} on ${message.subject}");
  });

  var sid = client.subscribe(subject: "foo");
}

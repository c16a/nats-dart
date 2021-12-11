import 'package:nats/nats.dart';

void main() async {
  var client = NatsClient(servers: ["nats://localhost:4222"], opts: null);
  await client.connect();
  client.publish("foo", "Hello World", replySubject: "bar");
}

import 'package:nats/nats.dart';

typedef CompletionHandler = void Function();
typedef OnExceptionHandler = void Function(Exception exception);
typedef MessageHandler = void Function(NatsMessage message);

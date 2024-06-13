import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:server/persistence/FrogMysqlClient.dart';

import 'middleware/cors_middleware.dart';

final mysqlClient = FrogMysqlClient();

Future<HttpServer> run(Handler handler, InternetAddress ip, int port) {
  return serve(corsMiddleware(handler.use(mysqlMiddleware())), ip, port);
}

Middleware mysqlMiddleware() {
  return (handler) {
    return handler.use(
      provider<FrogMysqlClient>(
        (context) => mysqlClient,
      ),
    );
  };
}

import 'package:dart_frog/dart_frog.dart';
import 'package:server/persistence/FrogMysqlClient.dart';

Handler mysqlMiddleware(Handler handler) {
  return handler.use(provider<FrogMysqlClient>((context) {
    print('Providing FrogMysqlClient to context');
    return FrogMysqlClient();
  }));
}

import 'package:dart_frog/dart_frog.dart';
import 'package:server/dataSource/ClimbingRouteDataSource.dart';
import 'package:server/persistence/FrogMysqlClient.dart';
import 'mysql_middleware.dart';

Handler middleware(Handler handler) {
  return handler.use(mysqlMiddleware).use(injectionHandler()).use(requestLogger());
}

Middleware injectionHandler() {
  return (handler) {
    return handler.use(
      provider<ClimbingRouteDataSource>(
        (context) {
          final client = context.read<FrogMysqlClient>();
          print('Providing ClimbingRouteDataSource to context with FrogMysqlClient');
          return ClimbingRouteDataSource(client);
        },
      ),
    );
  };
}

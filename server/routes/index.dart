import 'package:dart_frog/dart_frog.dart';

import '../middleware/cors_middleware.dart'; // Import du middleware CORS
import '../middleware/middleware.dart';
import '../middleware/mysql_middleware.dart'; // Import du middleware MySQL
import './users/[id].dart' as user_id;
import './users/index.dart' as users_index;

Handler middleware(Handler handler) {
  return handler
      .use(corsMiddleware)
      .use(mysqlMiddleware) // Utilisation du middleware MySQL
      .use(requestLogger())
      .use(injectionHandler());
}

Future<Response> onRequest(RequestContext context) async {
  return Response(statusCode: 200, body: 'User Management API');
}

Router setupRouter() {
  final router = Router()
    ..mount('/users', (Router router) {
      router
        ..all('/', users_index.onRequest)
        ..all('/<id>', user_id.onRequest);
    });
  return router;
}

Future<void> main() async {
  final handler = middleware(setupRouter().call);
  final handlerWithCors = corsMiddleware(handler);

  await serve(handlerWithCors, 'localhost', 8080);
}

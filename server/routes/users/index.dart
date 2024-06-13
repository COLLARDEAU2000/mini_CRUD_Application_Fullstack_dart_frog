import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:server/dataSource/ClimbingRouteDataSource.dart';
import 'package:server/persistence/FrogMysqlClient.dart';

Future<Response> onRequest(RequestContext context) async {
  try {
    final climbingRouteDataSource = ClimbingRouteDataSource(context.read<FrogMysqlClient>());
    print('Successfully read ClimbingRouteDataSource from context');
    final method = context.request.method;

    if (method == HttpMethod.get) {
      return await _getUsers(climbingRouteDataSource);
    } else if (method == HttpMethod.post) {
      return await _createUser(context, climbingRouteDataSource);
    }

    return Response(statusCode: 405, body: 'Method not allowed');
  } catch (e) {
    print('Error reading ClimbingRouteDataSource from context: $e');
    return Response(statusCode: 500, body: 'Internal Server Error');
  }
}

Future<Response> _getUsers(ClimbingRouteDataSource climbingRouteDataSource) async {
  try {
    final users = await climbingRouteDataSource.getAllUsers();
    return Response.json(body: users.map((user) => user.toJson()).toList());
  } catch (e) {
    print('Error in _getUsers: $e');
    return Response(statusCode: 500, body: 'Internal Server Error');
  }
}

Future<Response> _createUser(RequestContext context, ClimbingRouteDataSource climbingRouteDataSource) async {
  try {
    final body = jsonDecode(await context.request.body()) as Map<String, dynamic>;
    if (body['name'] == null || body['email'] == null) {
      return Response(
        statusCode: 400,
        body: "Le nom et l'email de l'utilisateur sont requis",
      );
    }

    final name = body['name'] as String;
    final email = body['email'] as String;


    await climbingRouteDataSource.createUser(name, email);

    return Response(statusCode: 201, body: 'User created');
  } catch (e) {
    print('Error in _createUser: $e');
    return Response(
        statusCode: 400,
        body: "Erreur lors de la création de l'utilisateur: $e");
  }
}

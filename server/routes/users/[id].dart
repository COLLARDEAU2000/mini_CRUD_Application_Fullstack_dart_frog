import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:server/dataSource/ClimbingRouteDataSource.dart';
import 'package:server/persistence/FrogMysqlClient.dart';
import 'package:server/persistence/models/ClimbingRouteEntity.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  try {
    final climbingRouteDataSource = ClimbingRouteDataSource(context.read<FrogMysqlClient>());
    print('Successfully read ClimbingRouteDataSource from context');
    final method = context.request.method;

    if (method == HttpMethod.get) {
      return await _getUser(climbingRouteDataSource, id);
    } else if (method == HttpMethod.put) {
      return await _updateUser(context, climbingRouteDataSource, id);
    } else if (method == HttpMethod.delete) {
      return await _deleteUser(climbingRouteDataSource, id);
    }

    return Response(statusCode: 405, body: 'Method not allowed');
  } catch (e) {
    print('Error reading ClimbingRouteDataSource from context: $e');
    return Response(statusCode: 500, body: 'Internal Server Error');
  }
}

Future<Response> _getUser(ClimbingRouteDataSource climbingRouteDataSource, String id) async {
  try {
    final user = await climbingRouteDataSource.getUserById(int.parse(id));
    if (user != null) {
      return Response.json(body: user.toJson());
    } else {
      return Response(statusCode: 404, body: 'User not found');
    }
  } catch (e) {
    print('Error in _getUser: $e');
    return Response(statusCode: 500, body: 'Internal Server Error');
  }
}

Future<Response> _updateUser(RequestContext context, ClimbingRouteDataSource climbingRouteDataSource, String id) async {
  try {
    final body = jsonDecode(await context.request.body()) as Map<String, dynamic>;
    if (body['name'] == null || body['email'] == null) {
      return Response(
        statusCode: 400,
        body: "Le nom et l'email de l'utilisateur sont requis",
      );
    }

    final user = ClimbingRouteEntity(
      id: int.parse(id),
      name: body['name'] as String,
      email: body['email'] as String,
    );

    await climbingRouteDataSource.updateUser(user);

    return Response(statusCode: 200, body: 'User updated');
  } catch (e) {
    print('Error in _updateUser: $e');
    return Response(
        statusCode: 400,
        body: "Erreur lors de la mise à jour de l'utilisateur: $e");
  }
}

Future<Response> _deleteUser(ClimbingRouteDataSource climbingRouteDataSource, String id) async {
  try {
    await climbingRouteDataSource.deleteUser(int.parse(id));
    return Response(statusCode: 200, body: 'User deleted');
  } catch (e) {
    print('Error in _deleteUser: $e');
    return Response(
        statusCode: 400,
        body: "Erreur lors de la suppression de l'utilisateur: $e");
  }
}

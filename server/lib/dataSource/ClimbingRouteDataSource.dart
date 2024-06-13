import 'package:server/persistence/FrogMysqlClient.dart';
import 'package:server/persistence/models/ClimbingRouteEntity.dart';

class ClimbingRouteDataSource {
  final FrogMysqlClient _mysqlClient;

  ClimbingRouteDataSource(this._mysqlClient);

  Future<List<ClimbingRouteEntity>> getAllUsers() async {
    final result = await _mysqlClient.execute('SELECT * FROM users');
    return result.rows
        .map((row) => ClimbingRouteEntity.fromRowAssoc(
            row.assoc() as Map<String, dynamic>))
        .toList();
  }

  Future<ClimbingRouteEntity?> getUserById(int id) async {
    final result = await _mysqlClient
        .execute('SELECT * FROM users WHERE id = :id', params: {'id': id});
    if (result.rows.isNotEmpty) {
      return ClimbingRouteEntity.fromRowAssoc(
          result.rows.first.assoc() as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  Future<void> createUser(String name, String email) async {
    await _mysqlClient.execute(
      'INSERT INTO users (name, email) VALUES (:name, :email)',
      params: {'name': name, 'email': email},
    );
  }

  Future<void> updateUser(ClimbingRouteEntity user) async {
    await _mysqlClient.execute(
      'UPDATE users SET name = :name, email = :email WHERE id = :id',
      params: {'id': user.id, 'name': user.name, 'email': user.email},
    );
  }

  Future<void> deleteUser(int id) async {
    await _mysqlClient
        .execute('DELETE FROM users WHERE id = :id', params: {'id': id});
  }
}

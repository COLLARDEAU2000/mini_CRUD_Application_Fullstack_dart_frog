import 'package:mysql_client/mysql_client.dart';

class FrogMysqlClient {
  static final FrogMysqlClient _instance = FrogMysqlClient._internal();
  MySQLConnection? _connection;

  factory FrogMysqlClient() {
    return _instance;
  }

  FrogMysqlClient._internal() {
    _connect();
  }

  Future<void> _connect() async {
    _connection = await MySQLConnection.createConnection(
      host: "localhost", // Adresse de votre serveur MySQL local
      port: 3306,
      userName: "root", // Votre nom d'utilisateur MySQL
      password: "root", // Votre mot de passe MySQL
      databaseName: "manager_users", // Le nom de votre base de données
    );
    await _connection?.connect();
  }

  Future<IResultSet> execute(
    String query, {
    Map<String, dynamic>? params,
  }) async {
    if (_connection == null || !_connection!.connected) {
      await _connect();
    }

    if (!_connection!.connected) {
      throw Exception('Could not connect to the database');
    }
    return _connection!.execute(query, params);
  }
}

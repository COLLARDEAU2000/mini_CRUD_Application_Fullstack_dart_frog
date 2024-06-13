import 'package:mysql_client/mysql_client.dart';

class FrogMysqlClient {
  /// Returns a singleton
  factory FrogMysqlClient() {
    return _inst;
  }

  FrogMysqlClient._internal() {
    _connect();
  }

  static final FrogMysqlClient _inst = FrogMysqlClient._internal();

  MySQLConnection? _connection;

  /// Initializes a connection to the database
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

  /// Execute a given query and checks for db connection
  Future<IResultSet> execute(
    String query, {
    Map<String, dynamic>? params,
    bool iterable = false,
  }) async {
    if (_connection == null || _connection?.connected == false) {
      await _connect();
    }

    if (_connection?.connected == false) {
      throw Exception('Could not connect to the database');
    }
    return _connection!.execute(query, params, iterable);
  }
}

void main() async {
  final mysqlClient = FrogMysqlClient();

  try {
    final result = await mysqlClient.execute('SELECT * FROM users');
    // Affichage des données de chaque ligne
    for (var row in result.rows) {
      print(row.assoc()); // Affiche les données de la ligne sous forme de map
    }
    print('Connected to MySQL database');
  } catch (e) {
    print('Failed to connect to MySQL database: $e');
  }
}

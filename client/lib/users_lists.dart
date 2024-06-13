import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

// URL de votre serveur Dart Frog
const String serverUrl = 'http://localhost:8080/users';
Future<List<dynamic>> getUsersFromServer() async {
  try {
    // Test de la connectivité en effectuant une requête GET vers votre serveur
    final response = await http.get(Uri.parse(serverUrl));

    if (response.statusCode == 200) {
      // Connexion réussie, récupération des données
      final List<dynamic> responseData = jsonDecode(response.body);
      List<dynamic> users = [];

      // Parcours des données et ajout dans la liste des utilisateurs
      for (var data in responseData) {
        // Création d'un objet utilisateur à partir des données
        var user = {
          'id': data['id'],
          'name': data['name'],
          'email': data['email'],
        };
        // Ajout de l'utilisateur à la liste des utilisateurs
        users.add(user);

        // Affichage de l'utilisateur ajouté
        print('Utilisateur ajouté : $user');
      }

      // Retourner la liste des utilisateurs
      return users;
    } else {
      // Erreur lors de la connexion, retourner une liste vide
      print('Erreur lors de la connexion : ${response.statusCode}');
      print('Message d\'erreur : ${response.reasonPhrase}');
      return [];
    }
  } catch (e) {
    // Erreur lors de la connexion, retourner une liste vide
    print('Erreur lors de la connexion : $e');
    return [];
  }
}

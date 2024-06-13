import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

// URL de votre serveur Dart Frog
const String serverUrl = 'http://localhost:8080/users';

Future<List<dynamic>> testConnectivity() async {
  try {
    // Test de la connectivité en effectuant une requête GET vers votre serveur
    final response = await http.get(Uri.parse(serverUrl));

    if (response.statusCode == 200) {
      // Connexion réussie, retourner la liste des utilisateurs récupérés
      return jsonDecode(response.body) as List<dynamic>;
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

void main() async {
  // Appel de la fonction de test de connectivité
  List<dynamic> users = await testConnectivity();

  // Affichage de la liste des utilisateurs récupérés
  if (users.isNotEmpty) {
    print('Connexion réussie. Utilisateurs récupérés :');
    users.forEach((user) {
      print('Nom: ${user['name']}, Email: ${user['email']}');
    });
  } else {
    print('Aucun utilisateur récupéré.');
  }
}

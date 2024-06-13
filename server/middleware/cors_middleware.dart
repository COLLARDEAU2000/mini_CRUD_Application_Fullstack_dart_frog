import 'package:dart_frog/dart_frog.dart';

Handler corsMiddleware(Handler handler) {
  return (context) async {
    // Vérifiez si la requête est une pré-vérification CORS (OPTIONS)
    if (context.request.method == HttpMethod.options) {
      return Response(
        statusCode: 204,
        headers: {
          // Autorise toutes les origines (vous pouvez remplacer * par l'origine spécifique de votre client Flutter si nécessaire)
          'Access-Control-Allow-Origin': '*',
          // Autorise les méthodes HTTP spécifiées
          'Access-Control-Allow-Methods': 'POST, GET, OPTIONS, PUT, DELETE, HEAD',
          // Autorise les en-têtes HTTP spécifiés
          'Access-Control-Allow-Headers': 'Content-Type',
        },
      );
    }

    // Si ce n'est pas une requête OPTIONS, traitez normalement la requête
    final response = await handler(context);

    // Ajoutez les en-têtes CORS à la réponse
    return response.copyWith(
      headers: {
        ...response.headers,
        // Autorise toutes les origines (vous pouvez remplacer * par l'origine spécifique de votre client Flutter si nécessaire)
        'Access-Control-Allow-Origin': '*',
        // Autorise les méthodes HTTP spécifiées
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        // Autorise les en-têtes HTTP spécifiés
        'Access-Control-Allow-Headers': 'Content-Type',
      },
    );
  };
}

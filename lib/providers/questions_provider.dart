import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quiz_generator/models/question_model.dart';

Future<List<Pregunta>> obtenerPreguntas(int tema, String dificultad, int cantidad) async {
  final url = Uri.parse(
      'https://opentdb.com/api.php?amount=$cantidad&category=$tema&difficulty=$dificultad&type=multiple');

  final respuesta = await http.get(url);
  //final String? traduccion;

  if (respuesta.statusCode == 200) {
    final data = json.decode(respuesta.body);
    final resultados = data['results'] as List;

    //print('Pregunta: ${resultados.map((json) => json['question']).toList()} Respuestas: ${resultados.map((json) => json['correct_answer']).toList()} Incorrectas: ${resultados.map((json) => json['incorrect_answers']).toList()}');
    //traduccion = await traducirTexto(resultados.map((json) => json['question']).join(' '));
    //print('Traducción: $traduccion');

    return resultados.map((json) => Pregunta.fromJson(json)).toList();
  } else {
    throw Exception('Error al cargar preguntas');
  }
}

Future<String> traducirTexto(String texto) async {
  final url = Uri.parse('https://libretranslate.com/translate');

  final response = await http.post(url, body: {
    'q': texto,
    'source': 'en',
    'target': 'es',
    'format': 'text',
  }, headers: {
    'Content-Type': 'application/x-www-form-urlencoded',
  });

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    return jsonResponse['translatedText'];
  } else {
    throw Exception('Error al traducir texto');
  }
}
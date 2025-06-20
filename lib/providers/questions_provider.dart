import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quiz_generator/models/question_model.dart';

Future<List<Pregunta>> obtenerPreguntas(int tema, String dificultad, int cantidad) async {
  final url = Uri.parse(
      'https://opentdb.com/api.php?amount=$cantidad&category=$tema&difficulty=$dificultad');

  final respuesta = await http.get(url);
  //final String? traduccion;
  print('respuesta: ${respuesta.body}');

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

// Evalúa una respuesta abierta usando la API de OpenAI (GPT-3.5 o GPT-4)
// Evalúa una respuesta abierta usando la API de OpenAI (GPT-3.5 o GPT-4)
Future<bool> evaluarPregunta(String pregunta, String respuestaUsuario) async {
  const apiKey = '';
  final url = Uri.parse('https://api.openai.com/v1/chat/completions');

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $apiKey',
  };

  final body = jsonEncode({
    'model': 'gpt-3.5-turbo',
    'messages': [
      {
        'role': 'system',
        'content': 'Eres un evaluador de preguntas tipo examen. Devuelve solo "sí" o "no" dependiendo si la respuesta del estudiante es correcta o no, sin explicaciones.'
      },
      {
        'role': 'user',
        'content': 'Pregunta: $pregunta\nRespuesta del estudiante: $respuestaUsuario\nEs correcta?'
      },
    ],
    'temperature': 0,
  });

  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final content = data['choices'][0]['message']['content'].toString().toLowerCase();

    // Evalúa si la respuesta fue "sí"
    return content.contains('sí') || content.contains('yes');
  } else {
    throw Exception('Error al evaluar respuesta con OpenAI: ${response.body}');
  }
}

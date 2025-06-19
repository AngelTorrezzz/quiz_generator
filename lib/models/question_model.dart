class Pregunta {
  final String pregunta;
  final List<String> opciones;
  final String correcta;

  Pregunta({required this.pregunta, required this.opciones, required this.correcta});

  factory Pregunta.fromJson(Map<String, dynamic> json) {
    final opciones = [...json['incorrect_answers'], json['correct_answer']];
    opciones.shuffle();

    return Pregunta(
      pregunta: json['question'],
      opciones: List<String>.from(opciones),
      correcta: json['correct_answer'],
    );
  }
}
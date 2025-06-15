import 'package:flutter/material.dart';

class FormQuestions extends StatelessWidget {
  const FormQuestions({super.key});

  @override
  Widget build(BuildContext context) {
    // Simulación de preguntas (podrían venir de una API)
    final preguntas = [
      '¿Cuál es la capital de Francia?',
      '¿Qué órgano bombea la sangre?',
      '¿En qué año llegó el hombre a la luna?',
    ];

    final color = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cuestionario: Historia',
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 24,
          ),
        ),
      ),
      body: Container(
        color: color.secondary,
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: preguntas.length,
          itemBuilder: (context, index) {
            return PreguntaCard(
              numero: index + 1,
              texto: preguntas[index],
            );
          },
        ),
      ),
    );
  }
}

class PreguntaCard extends StatelessWidget {
  final int numero;
  final String texto;

  const PreguntaCard({
    super.key,
    required this.numero,
    required this.texto,
  });

  @override
  Widget build(BuildContext context) {
    // Estilo de texto y colores
    final color = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Theme.of(context).colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pregunta $numero',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22, color: color.secondary),
            ),
            const SizedBox(height: 8),
            Text(
              texto,
              style: TextStyle(fontSize: 17, color: color.secondary),
            ),
            const SizedBox(height: 16),
            // Opciones de respuesta (simuladas)
            Column(
              children: List.generate(4, (i) {
                return ListTile(
                  leading: const Icon(Icons.radio_button_unchecked),
                  title: Text(
                    'Opción ${String.fromCharCode(65 + i)}',
                    style: TextStyle(color: color.secondary, fontSize: 15),
                  ),
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  onTap: null, // No funcional
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
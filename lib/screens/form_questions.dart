import 'package:flutter/material.dart';
import 'package:quiz_generator/models/question_model.dart';
import 'package:quiz_generator/providers/questions_provider.dart';
import 'dart:math';

class FormQuestions extends StatefulWidget {

  // Constructor que recibe los parámetros necesarios para el cuestionario
  const FormQuestions({
    super.key,
    required this.temaString,
    required this.temaId,
    required this.dificultadSeleccionadaString,
    required this.dificultadSeleccionadaId,
    required this.cantidadPreguntas,
    required this.tipoPreguntaSeleccionada,
  });

  // Variables necesarias para el cuestionario que provienen del formulario
  final String temaString; // Nombre del tema
  final int temaId; // ID del tema
  final String dificultadSeleccionadaString; // Nombre de la dificultad seleccionada
  final String dificultadSeleccionadaId; // ID de la dificultad seleccionada
  final int cantidadPreguntas; // Cantidad de preguntas a mostrar
  final String tipoPreguntaSeleccionada;// ID del tipo de pregunta seleccionada (opcional, no se usa en este ejemplo)


  // Método para obtener las preguntas según los parámetros, util para inicializar el Future
  @override
  State<FormQuestions> createState() => _FormQuestionsState();
}

class _FormQuestionsState extends State<FormQuestions> {
  // Future que obtiene las preguntas según los parámetros del constructor
  late Future<List<Pregunta>> _preguntasFuture;
  // Lista para almacenar las respuestas del usuario
  late List<String?> respuestasUsuario;
  // Variable para almacenar los tipos de pregunta por pregunta, se genera en este widget
  late List<String> tipoPreguntaPorPregunta;

  bool enviado = false;
  int aciertos = 0;
  bool yaEnvio = false;

  @override
  void initState() {
    //print('TemaString: ${widget.temaString}, TemaId: ${widget.temaId}, DificultadString: ${widget.dificultadSeleccionadaString}, DificultadId: ${widget.dificultadSeleccionadaId}, Cantidad: ${widget.cantidadPreguntas}');
    super.initState();
    _preguntasFuture = obtenerPreguntas(
      widget.temaId,
      widget.dificultadSeleccionadaId,
      widget.cantidadPreguntas,
    ).then((preguntas) {
      for (var p in preguntas) {
        p.opciones.shuffle(); // Mezclar las opciones de cada pregunta
      }
      return preguntas;
    });

    // Inicializar la lista de respuestas del usuario con null
    // para cada pregunta, de acuerdo a la cantidad de preguntas seleccionadas
    respuestasUsuario = List<String?>.filled(widget.cantidadPreguntas, null);

    tipoPreguntaPorPregunta = List.generate(widget.cantidadPreguntas, (index) {
    if (widget.tipoPreguntaSeleccionada == 'Ambas') {
      return (DateTime.now().microsecondsSinceEpoch + index + Random().nextInt(100)) % 2 == 0
          ? 'Opción múltiple'
          : 'Abierta';
    } else {
      return widget.tipoPreguntaSeleccionada;
    }
  });

  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: color.secondary,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.temaString,
              style: TextStyle(color: color.secondary, fontSize: 24),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Tipo: ${widget.tipoPreguntaSeleccionada}', style: TextStyle(color: color.secondary.withOpacity(0.8), fontSize: 12)),
                Text('Cantidad: ${widget.cantidadPreguntas}', style: TextStyle(color: color.secondary.withOpacity(0.8), fontSize: 12)),
                Text('Dificultad: ${widget.dificultadSeleccionadaString}', style: TextStyle(color: color.secondary.withOpacity(0.8), fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fondo4.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.1),
              BlendMode.darken,
            ),
          ),
        ),
        child: Center(
          // FutureBuilder para manejar la carga de preguntas
          // y mostrar el cuestionario una vez que se hayan obtenido las preguntas
          child: FutureBuilder<List<Pregunta>>(
            future: _preguntasFuture,
            // Builder que construye el widget según el estado del Future
            // Si está esperando, muestra un CircularProgressIndicator
            // context especifica el contexto actual
            // snapshot contiene el resultado del Future
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              // Si el Future se completó con éxito, obtenemos las preguntas
              final preguntas = snapshot.data!;
              
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(25.0),
                      itemCount: preguntas.length,
                      itemBuilder: (context, index) {
                        final p = preguntas[index];
                        return PreguntaCard(
                          numero: index + 1,
                          texto: p.pregunta,
                          opciones: p.opciones,
                          respuestaSeleccionada: respuestasUsuario[index],
                          correcta: p.correcta,
                          enviado: enviado,
                          onRespuestaSeleccionada: (valor) {
                            if (!enviado) {
                              setState(() {
                                respuestasUsuario[index] = valor;
                              });
                            }
                          },
                          tipoPregunta: tipoPreguntaPorPregunta[index],
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: (enviado || respuestasUsuario.contains(null) || respuestasUsuario.contains(''))
                              ? null
                              : () async {
                                  yaEnvio = true;
                                  int correctas = 0;
                                  final preguntas = await _preguntasFuture;

                                  for (int i = 0; i < preguntas.length; i++) {
                                    final tipo = tipoPreguntaPorPregunta[i];
                                    final respuesta = respuestasUsuario[i];
                                    final pregunta = preguntas[i];

                                    if (tipo == 'Opción múltiple') {
                                      if (respuesta == pregunta.correcta) correctas++;
                                    } else {
                                      try {
                                        //final esCorrecta = await evaluarPregunta(pregunta.pregunta, respuesta ?? '');
                                        
                                        final esCorrecta = respuesta != null && respuesta.isNotEmpty && respuesta.toLowerCase() == pregunta.correcta.toLowerCase();
                                        print('Pregunta ${i + 1}: ${pregunta.pregunta}, Respuesta: $respuesta, Correcta: ${pregunta.correcta}, Evaluación: $esCorrecta');

                                        if (esCorrecta) correctas++;
                                      } catch (e) {
                                        print('Error al evaluar pregunta ${i + 1}: $e');
                                      }
                                    }
                                  }

                                  setState(() {
                                    enviado = true;
                                    aciertos = correctas;
                                  });

                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text('Resultado'),
                                      content: Text('Obtuviste $correctas de ${preguntas.length} respuestas correctas.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(),
                                          child: const Text('Cerrar'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                          icon: Icon(Icons.check, color: Theme.of(context).colorScheme.secondary),
                          label: Text(
                            'Enviar respuestas',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 18,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton.icon(
                          onPressed: (!yaEnvio)
                              ? null
                              : () {
                                  yaEnvio = false;
                                  setState(() {
                                    enviado = false;
                                    respuestasUsuario = List<String?>.filled(widget.cantidadPreguntas, null);
                                    aciertos = 0;
                                    _preguntasFuture = obtenerPreguntas(
                                      widget.temaId,
                                      widget.dificultadSeleccionadaId,
                                      widget.cantidadPreguntas,
                                    ).then((preguntas) {
                                      for (var p in preguntas) {
                                        p.opciones.shuffle(); // Mezclar de nuevo
                                      }
                                      return preguntas;
                                    });
                                  });
                                },
                          icon: Icon(Icons.restart_alt, color: Theme.of(context).colorScheme.secondary),
                          label: Text(
                            'Nuevo cuestionario',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 18,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: color.primary,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}


class PreguntaCard extends StatefulWidget {
  final int numero;
  final String texto;
  final List<String> opciones;
  final String? respuestaSeleccionada;
  final void Function(String) onRespuestaSeleccionada;
  final String correcta;
  final bool enviado;
  final String tipoPregunta;


  const PreguntaCard({
    super.key,
    required this.numero,
    required this.texto,
    required this.opciones,
    required this.respuestaSeleccionada,
    required this.onRespuestaSeleccionada,
    required this.correcta,
    required this.enviado,
    required this.tipoPregunta,
  });

  @override
  State<PreguntaCard> createState() => _PreguntaCardState();
}

class _PreguntaCardState extends State<PreguntaCard> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.respuestaSeleccionada ?? '');
  }

  @override
  void didUpdateWidget(covariant PreguntaCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.respuestaSeleccionada != _controller.text) {
      _controller.text = widget.respuestaSeleccionada ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: color.primary,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pregunta ${widget.numero}',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22, color: color.secondary),
            ),
            const SizedBox(height: 8),
            Text(
              widget.texto,
              style: TextStyle(fontSize: 17, color: color.secondary),
            ),
            const SizedBox(height: 16),
            if (widget.tipoPregunta == 'Opción múltiple') ...widget.opciones.map((opcion) {
              final seleccionada = widget.respuestaSeleccionada == opcion;
              final esCorrecta = opcion == widget.correcta;

              Color? tileColor;
              IconData icon = Icons.radio_button_unchecked;
              Color iconColor = color.secondary;

              if (widget.enviado) {
                if (seleccionada && esCorrecta) {
                  tileColor = Colors.green.withOpacity(0.3);
                  icon = Icons.check_circle;
                  iconColor = Colors.green;
                } else if (seleccionada && !esCorrecta) {
                  tileColor = Colors.red.withOpacity(0.3);
                  icon = Icons.cancel;
                  iconColor = Colors.red;
                } else if (esCorrecta) {
                  tileColor = Colors.green.withOpacity(0.1);
                  icon = Icons.check_circle_outline;
                  iconColor = Colors.green;
                }
              } else if (seleccionada) {
                icon = Icons.radio_button_checked;
                iconColor = Colors.blueAccent;
              }

              return ListTile(
                tileColor: tileColor,
                leading: Icon(icon, color: iconColor),
                title: Text(opcion, style: TextStyle(color: color.secondary, fontSize: 16)),
                dense: true,
                visualDensity: VisualDensity.compact,
                onTap: widget.enviado ? null : () => widget.onRespuestaSeleccionada(opcion),
              );
            }).toList()
            else ...[
              TextField(
                controller: _controller,
                enabled: !widget.enviado,
                onChanged: widget.onRespuestaSeleccionada,
                style: TextStyle(color: color.secondary),
                decoration: InputDecoration(
                  hintText: 'Escribe tu respuesta...',
                  hintStyle: TextStyle(color: color.secondary.withOpacity(0.6)),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: color.tertiary)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: color.secondary, width: 2)),
                  suffixIcon: widget.enviado
                      ? (widget.respuestaSeleccionada?.toLowerCase() == widget.correcta.toLowerCase()
                          ? Icon(Icons.check_circle, color: Colors.green)
                          : Icon(Icons.cancel, color: Colors.red))
                      : null,
                ),
              ),
              if (widget.enviado)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Respuesta correcta: ${widget.correcta}',
                    style: TextStyle(
                      color: color.secondary,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ]
          ],
        ),
      ),
    );
  }
}


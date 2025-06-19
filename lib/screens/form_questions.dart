import 'package:flutter/material.dart';
import 'package:quiz_generator/models/question_model.dart';
import 'package:quiz_generator/providers/questions_provider.dart';

class FormQuestions extends StatefulWidget {
  const FormQuestions({
    super.key,
    required this.temaString,
    required this.temaId,
    required this.dificultadSeleccionadaString,
    required this.dificultadSeleccionadaId,
    required this.cantidadPreguntas,
  });

  final String temaString;
  final int temaId;
  final String dificultadSeleccionadaString;
  final String dificultadSeleccionadaId;
  final int cantidadPreguntas;

  @override
  State<FormQuestions> createState() => _FormQuestionsState();
}

class _FormQuestionsState extends State<FormQuestions> {
  late Future<List<Pregunta>> _preguntasFuture;
  late List<String?> respuestasUsuario;

  bool enviado = false;
  int aciertos = 0;
  bool yaEnvio = false;

  @override
  void initState() {
    //print('TemaString: ${widget.temaString}, TemaId: ${widget.temaId}, DificultadString: ${widget.dificultadSeleccionadaString}, DificultadId: ${widget.dificultadSeleccionadaId}, Cantidad: ${widget.cantidadPreguntas}');
    super.initState();
    _preguntasFuture = obtenerPreguntas(widget.temaId, widget.dificultadSeleccionadaId, widget.cantidadPreguntas);
    respuestasUsuario = List<String?>.filled(widget.cantidadPreguntas, null);
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
                Text('Dificultad: ${widget.dificultadSeleccionadaString}', style: TextStyle(color: color.secondary.withOpacity(0.8), fontSize: 14)),
                Text('Preguntas: ${widget.cantidadPreguntas}', style: TextStyle(color: color.secondary.withOpacity(0.8), fontSize: 14)),
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
          child: FutureBuilder<List<Pregunta>>(
            future: _preguntasFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
          
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
                          onPressed: (enviado || respuestasUsuario.contains(null))
                              ? null
                              : () {
                                  yaEnvio = true;
                                  int correctas = 0;
                                  for (int i = 0; i < preguntas.length; i++) {
                                    if (respuestasUsuario[i] == preguntas[i].correcta) {
                                      correctas++;
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
                                    // Reiniciar el estado del cuestionario
                                    yaEnvio = false;
                                    setState(() {
                                      enviado = false;
                                      respuestasUsuario = List<String?>.filled(widget.cantidadPreguntas, null);
                                      // Opcional: puedes resetear aciertos a 0 también
                                      aciertos = 0;
                                    });
                                  },
                          icon: Icon(Icons.restart_alt, color: Theme.of(context).colorScheme.secondary),
                          label: Text(
                            'Reintentar',
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


  const PreguntaCard({
    super.key,
    required this.numero,
    required this.texto,
    required this.opciones,
    required this.respuestaSeleccionada,
    required this.onRespuestaSeleccionada,
    required this.correcta,
    required this.enviado,
  });

  @override
  State<PreguntaCard> createState() => _PreguntaCardState();
}

class _PreguntaCardState extends State<PreguntaCard> {
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
            ...widget.opciones.map((opcion) {
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
            }).toList(),
          ],
        ),
      ),
    );
  }
}

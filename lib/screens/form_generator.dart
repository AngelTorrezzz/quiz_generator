import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_generator/screens/form_questions.dart';

class FormGenerator extends StatefulWidget {
  const FormGenerator(this.title, {super.key});
  final String title;

  @override
  State<FormGenerator> createState() => _FormGeneratorState();
}

class _FormGeneratorState extends State<FormGenerator> {
  final Map<String, int> temas = {
    'Computación': 18,     // Science: Computers
    'Matemáticas': 19,      // Science: Mathematics
    'Ciencias': 17,         // Science & Nature
    'Geografía': 22,        // Geography
    'Literatura': 10,       // Entertainment: Books
    'Historia': 23,         // History
  };
  
  final Map<String, String> dificultades = {
    'Fácil': 'easy',
    'Medio': 'medium',
    'Difícil': 'hard',
  };
  
  String? temaSeleccionado;
  String? dificultadSeleccionada;
  int? cantidadPreguntas;
  String? tipoPreguntaSeleccionada;
  final Map<String, String> tiposPregunta = {
    'Opción múltiple': 'multiple',
    'Abiertas': 'open', // esto es simbólico; la API no lo usa, pero tú podría filtrarse si es necesario
    'Ambas': 'all', // para incluir todos los tipos
  };


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 24,
          ),
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
          child: SingleChildScrollView(
            child: Card(
              color: Theme.of(context).colorScheme.primary,
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        Text(
                          'Tema',
                          style: TextStyle(
                            fontSize: 24,
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                     DropdownButtonFormField<String>(
                      hint: Text(
                        'Ej. Computación, Matemáticas, Ciencias...',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                      dropdownColor: Theme.of(context).colorScheme.tertiary,
                      value: temaSeleccionado,
                      items: temas.keys
                          .map((tema) => DropdownMenuItem<String>(
                                value: tema,
                                child: Text(
                                  tema,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          temaSeleccionado = value!;
                        });
                      },
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 2),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        Text(
                          'Tipo de preguntas',
                          style: TextStyle(fontSize: 24, color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    DropdownButtonFormField<String>(
                      hint: Text(
                        'Selecciona el tipo de pregunta',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                      dropdownColor: Theme.of(context).colorScheme.tertiary,
                      value: tipoPreguntaSeleccionada,
                      items: tiposPregunta.keys.map((tipo) {
                        return DropdownMenuItem<String>(
                          value: tipo,
                          child: Text(
                            tipo,
                            style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.secondary),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          tipoPreguntaSeleccionada = value!;
                        });
                      },
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 2),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                     Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        Text(
                          'Cantidad de preguntas',
                          style: TextStyle(fontSize: 24, color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Ej: 10, 20, 30...',
                        hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 2),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (value) {
                        // Aquí puedes manejar el valor ingresado si es necesario
                        cantidadPreguntas = int.tryParse(value) ?? 0;
                        //print('Cantidad de preguntas: $cantidadPreguntas');
                        if (cantidadPreguntas! < 1) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Por favor, ingresa un número mayor a 0',
                                style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                              ),
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              duration: const Duration(milliseconds: 1500),
                            ),
                          );
                        } else {
                          
                        }
                      },
                    ),
                    SizedBox(height: 16),

                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        Text(
                          'Dificultad',
                          style: TextStyle(fontSize: 24, color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    DropdownButtonFormField<String>(
                      hint: Text(
                        'Selecciona la dificultad',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                      dropdownColor: Theme.of(context).colorScheme.tertiary,
                      value: dificultadSeleccionada,
                      items: dificultades.keys
                          .map((nivel) => DropdownMenuItem(
                                value: nivel,
                                child: Text(
                                  nivel,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          dificultadSeleccionada = value;
                        });
                      },
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (temaSeleccionado == null || dificultadSeleccionada == null || cantidadPreguntas == null || (cantidadPreguntas != null && cantidadPreguntas! < 1) || tipoPreguntaSeleccionada == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Por favor, completa todos los campos',
                                  style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                                ),
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FormQuestions(
                                  temaString: temaSeleccionado!,
                                  temaId: temas[temaSeleccionado!]!,
                                  dificultadSeleccionadaString: dificultadSeleccionada!,
                                  dificultadSeleccionadaId: dificultades[dificultadSeleccionada!]!,
                                  cantidadPreguntas: cantidadPreguntas!,
                                  tipoPreguntaSeleccionada: tipoPreguntaSeleccionada!,
                                ),
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Generando Formulario...',
                                  style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                                ),
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                duration: const Duration(milliseconds: 750),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.tertiary,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          'Generar',
                          style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

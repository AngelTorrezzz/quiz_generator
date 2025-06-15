import 'package:flutter/material.dart';

class FormGenerator extends StatefulWidget {
  const FormGenerator(this.title, {super.key});
  final String title;

  @override
  State<FormGenerator> createState() => _FormGeneratorState();
}

class _FormGeneratorState extends State<FormGenerator> {
  final List<String> dificultades = ['Fácil', 'Medio', 'Difícil', 'Experto'];
  String? dificultadSeleccionada;

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
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Ej: Historia, Matemáticas, Ciencias...',
                        hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
                          fontSize: 16,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 2),
                        ),
                      ),
                      style: TextStyle(color: Theme.of(context).colorScheme.secondary),
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
                          fontSize: 16,
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
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                      dropdownColor: Theme.of(context).colorScheme.tertiary,
                      value: dificultadSeleccionada,
                      items: dificultades
                          .map((nivel) => DropdownMenuItem(
                                value: nivel,
                                child: Text(
                                  nivel,
                                  style: TextStyle(
                                    fontSize: 16,
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
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Formulario enviado',
                                style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                              ),
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              duration: const Duration(milliseconds: 750),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.tertiary,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          'Confirmar',
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

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';

class CreateRecipe extends StatefulWidget {
  const CreateRecipe({Key? key}) : super(key: key);

  @override
  State<CreateRecipe> createState() => _CreateRecipeState();
}

class _CreateRecipeState extends State<CreateRecipe> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  late String name, time, people;

  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerImage = TextEditingController();
  final TextEditingController _controllerTime = TextEditingController();
  final TextEditingController _controllerPeople = TextEditingController();
  final List<TextEditingController> _ingredientControllers = [
    TextEditingController()
  ];

  XFile? image; //this is the state variable

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 58.0),
                child: Center(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Center(
                              child: Text(
                                'Nueva receta',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 110, 8, 211),
                                  fontFamily: 'Linden Hill',
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.cancel,
                                size: 25,
                              ),
                              color: Colors.black,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () async {
                              if (image != null) {
                                setState(() {
                                  image = null;
                                });
                              } else {
                                final ImagePicker _picker = ImagePicker();
                                final img = await _picker.pickImage(
                                    source: ImageSource.gallery);
                                setState(() {
                                  image = img;
                                });
                              }
                            },
                            label: Text(image != null
                                ? 'Eliminar imagen'
                                : 'Elige una imagen'),
                            icon: Icon(
                                image != null ? Icons.delete : Icons.image),
                          ),
                          if (image != null)
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Container(
                                width: 100,
                                height: 100,
                                child: Image.file(File(image!.path)),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          style: const TextStyle(fontSize: 14),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Nombre',
                            hintText: 'Introduzca un nombre...',
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 12,
                            ),
                          ),
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: "Introduzca un nombre."),
                          ]),
                          onSaved: (String? value) {
                            name = value!;
                          },
                        ),
                      ),
                      const SizedBox(height: 18),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          style: const TextStyle(fontSize: 14),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Comensales',
                            hintText: 'Introduzca una cantidad...',
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 12,
                            ),
                          ),
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText:
                                    "Introduzca una cantidad de comensales."),
                          ]),
                          onSaved: (String? value) {
                            name = value!;
                          },
                        ),
                      ),
                      const SizedBox(height: 18),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          style: const TextStyle(fontSize: 14),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Tpo de elaboración (en minutos)',
                            hintText: 'Introduzca un tiempo de elaboración...',
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 12,
                            ),
                          ),
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText:
                                    "Introduzca un tiempo de elaboración."),
                          ]),
                          onSaved: (String? value) {
                            name = value!;
                          },
                        ),
                      ),
                      _buildIngredientFields(),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 110, 8, 211)),
                          elevation: MaterialStateProperty.all(8),
                          shadowColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 30, 30, 30)),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10)),
                          textStyle: MaterialStateProperty.all(
                              const TextStyle(fontSize: 30)),
                        ),
                        onPressed: () async {
                          if (formkey.currentState!.validate()) {
                            formkey.currentState!.save();
                            // Aquí puedes acceder a name, image, time, people y _ingredientControllers
                            // para procesar la información de la receta.
                          }
                        },
                        child: const Text(
                          'Crear receta',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Linden Hill',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIngredientFields() {
    return Column(
      children: [
        for (int i = 0; i < _ingredientControllers.length; i++)
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 32.0, right: 0.0, top: 16, bottom: 0),
                  child: TextFormField(
                    controller: _ingredientControllers[i],
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(fontSize: 14),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Ingrediente y cantidad',
                      hintText: 'Introduzca un ingrediente y su cantidad...',
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 12,
                      ),
                    ),
                    validator: MultiValidator([
                      RequiredValidator(
                          errorText: "Introduzca un ingrediente."),
                      EmailValidator(errorText: "Introduzca un ingrediente"),
                    ]),
                    onSaved: (String? value) {
                      // Puedes guardar cada ingrediente aquí si es necesario
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    right: 16.0), // Ajusta el valor según sea necesario
                child: IconButton(
                  padding: EdgeInsets.only(
                      right: 8.0, top:16.0), // Ajusta el valor según sea necesario
                  icon: Icon(Icons.cancel, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      _ingredientControllers.removeAt(i);
                    });
                  },
                ),
              ),
            ],
          ),
        Container(
          margin:
              const EdgeInsets.only(left: 18.0, right: 32.0, top: 4, bottom: 0),
          child: TextButton(
            onPressed: () {
              // Añadir un nuevo TextEditingController para el nuevo ingrediente
              _ingredientControllers.add(TextEditingController());
              setState(() {});
            },
            child: const Row(
              children: [
                Icon(Icons.add, color: Color.fromARGB(255, 110, 8, 211)),
                SizedBox(width: 5),
                Text(
                  "Añadir ingrediente",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:plato_perfecto/login_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? errorMessageLogin = '';
  bool isLogin = false;
  bool _obscureText = true;
  bool passwordVisible = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  late String email, password;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  Future<UserCredential> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return "* Required";
    } else if (value.length < 6) {
      return "Password should be atleast 6 characters";
    } else if (value.length > 15) {
      return "Password should not be greater than 15 characters";
    } else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Form(
                key: formkey,
                child: Column(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Center(
                      child: Column(children: [
                        SizedBox(
                          width: 180,
                          height: 120,
                          child: Image.asset(
                              'assets/images/plato_perfecto_logo.png'),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Regístrate para tener todas tus recetas en un único lugar',
                          style: TextStyle(
                            color: Color.fromARGB(255, 110, 8, 211),
                            fontFamily: 'Linden Hill',
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 48),
                          child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(fontSize: 14),
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Nombre',
                                  hintText: 'Introduzca su nombre...',
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 6, horizontal: 12)),
                              validator: MultiValidator([
                                RequiredValidator(
                                    errorText: "Introduzca un nombre."),
                              ])),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 48.0, right: 48.0, top: 16, bottom: 0),
                          child: TextFormField(
                            controller: _controllerEmail,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(fontSize: 14),
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Email',
                                hintText: 'Introduzca su email...',
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 12)),
                            validator: MultiValidator([
                              RequiredValidator(
                                  errorText: "Introduzca un email."),
                              EmailValidator(
                                  errorText: "Introduzca un email válido"),
                            ]),
                            onSaved: (String? value) {
                              email = value!;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 48.0, right: 48.0, top: 16, bottom: 0),
                          child: TextFormField(
                            controller: _controllerPassword,
                            obscureText: true,
                            style: const TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: 'Password',
                                hintText: 'Introduzca su contraseña',
                                suffixIcon: IconButton(
                                  icon: Icon(passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    setState(
                                      () {
                                        passwordVisible = !passwordVisible;
                                      },
                                    );
                                  },
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 12)),
                            validator: MultiValidator([
                              RequiredValidator(
                                  errorText:
                                      "El email o la contraseña son incorrectos."),
                              MinLengthValidator(6,
                                  errorText:
                                      "La contraseña debe tener mínimo 6 carácteres"),
                            ]),
                            onSaved: (String? value) {
                              password = value!;
                            },
                            //validatePassword,        //Function to check validation
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: 212,
                          height: 39,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      const Color.fromARGB(255, 110, 8, 211)),
                                  elevation: MaterialStateProperty.all(8),
                                  shadowColor: MaterialStateProperty.all(
                                      const Color.fromARGB(255, 30, 30, 30)),
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.all(5)),
                                  textStyle: MaterialStateProperty.all(
                                      const TextStyle(fontSize: 30))),
                              onPressed: () async {
                                if (formkey.currentState!.validate()) {
                                  formkey.currentState!.save();
                                  UserCredential? credentials =
                                      await createUserWithEmailAndPassword(
                                          email, password);
                                  if (credentials.user != null) {
                                    await credentials.user!
                                        .sendEmailVerification();
                                    Fluttertoast.showToast(
                                        msg: "Revise su bandeja de correo electrónico (o Spam)",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 2,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  }
                                } else {}
                              },
                              child: const Text(
                                'Registrarse',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Linden Hill',
                                ),
                              )),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        SignInButton(
                          Buttons.GoogleDark,
                          text: "Registrarse con Google",
                          onPressed: () {},
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const Text('¿Ya tienes una cuenta?'),
                        TextButton(
                          onPressed: () {
                            isLogin = !isLogin;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const LoginScreen()));
                          },
                          style: ButtonStyle(
                            textStyle: MaterialStateProperty.all(
                              const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 110, 8, 211),
                              ),
                            ),
                          ),
                          child: const Text('Inicia sesión'),
                        ),
                      ]),
                    ),
                  ),
                ]))));
  }
}

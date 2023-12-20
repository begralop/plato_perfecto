import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:plato_perfecto/auth.dart';
import 'package:plato_perfecto/presentation/pages/home/home_page.dart';
import 'package:plato_perfecto/presentation/pages/register/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plato_perfecto/presentation/navigation/navigation_routes.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLogin = false;
  String? errorMessageLogin = '';
  bool passwordVisible = true;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String? name, imageUrl, userEmail, uid;
  late String email, password;
  FirebaseAuth auth = FirebaseAuth.instance;

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (userCredential.user?.emailVerified == false) {
        Fluttertoast.showToast(
            msg: "El usuario no ha realizado la verificación de correo.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        return userCredential.user;
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "El usuario o la contraseña no son correctos.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        textColor: Colors.white,
      );
    }
    return null;
  }

  Future<User?> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    if (googleUser != null) {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(
        GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        ),
      );
      setState(() {
        isLogin = true;
      });

      User? user = userCredential.user;
      // ignore: use_build_context_synchronously
      GoRouter.of(context).push(
        NavigationRoutes.HOME_ROUTE,
        extra: user,
      );
      /*   SharedPreferences prefs = await SharedPreferences.getInstance(); 
      prefs.setBool('auth', true);  */
      return user;
    }
    return null;
  }

  final User? user = Auth().currentUser;

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
                          'Todas tus recetas en un único lugar',
                          style: TextStyle(
                            color: Color.fromARGB(255, 110, 8, 211),
                            fontFamily: 'Linden Hill',
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 18),
                        SignInButton(
                          Buttons.GoogleDark,
                          text: "Continuar con Google",
                          onPressed: () {
                            signInWithGoogle();
                          },
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 106,
                              decoration: const ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 0.5, color: Colors.black),
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text('o',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  )),
                            ),
                            Container(
                              width: 106,
                              decoration: const ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 0.5, color: Colors.black),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 48),
                          child: TextFormField(
                            style: const TextStyle(fontSize: 14),
                            keyboardType: TextInputType.emailAddress,
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
                            obscureText: passwordVisible,
                            style: const TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: 'Password',
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
                                hintText: 'Introduzca su contraseña',
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 12)),
                            validator: MultiValidator([
                              RequiredValidator(
                                  errorText:
                                      "El email o la contraseña son incorrectos."),
                            ]),
                            onSaved: (String? value) {
                              password = value!;
                            },
                            //validatePassword,        //Function to check validation
                          ),
                        ),
                        const SizedBox(
                          height: 16,
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
                                  User? user = await signInWithEmailAndPassword(
                                      email, password);
                                  if (user != null) {
                                    if (user.emailVerified == true) {
                                      GoRouter.of(context).push(
                                        NavigationRoutes.HOME_ROUTE,
                                        extra: user,
                                      );
                                    }
                                  }
                                } else {}
                              },
                              child: const Text(
                                'Login',
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
                        const Text('¿Aún no tienes una cuenta?'),
                        TextButton(
                          onPressed: () {
                            isLogin = !isLogin;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const RegisterPage()));
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
                          child: const Text('Crear cuenta'),
                        ),
                      ]),
                    ),
                  ),
                ]))));
  }
}

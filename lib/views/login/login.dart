// ignore_for_file: use_build_context_synchronously

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tu_mercado/components/button.dart';
import 'package:tu_mercado/components/text_field.dart';
import 'package:tu_mercado/config/colors.dart';
import 'package:tu_mercado/config/styles.dart';
import 'package:tu_mercado/models/User.dart';
import 'package:tu_mercado/models/user_data.dart';
import 'package:tu_mercado/providers/auth_provider.dart';
import 'package:tu_mercado/providers/user_data_provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //Controllers block
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //Var Definition
  String _email = "";
  String _password = "";
  bool rememberMe = false;
  String deviceID = "";
  //preferences block
  late SharedPreferences prefs;

  @override
  void initState() {
    getPreferences();
    _emailController.addListener(() {
      _email = _emailController.text;
    });
    _passwordController.addListener(() {
      _password = _passwordController.text;
    });
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void getPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      rememberMe = prefs.getBool("rememberMe") ?? true;
      deviceID = prefs.getString("deviceID") ?? "void";
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    // ignore: no_leading_underscores_for_local_identifiers

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: height * 0.01),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: const Image(
                    image: AssetImage('lib/assets/logo.png'),
                    width: 90,
                  ),
                ),
                const Text(
                  "Bienvenido",
                  style: TextStyles.title,
                ),
              ],
            ),
          ),
          SizedBox(height: height * 0.05),
          Expanded(
            child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                decoration: const BoxDecoration(
                    color: Palette.primary,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                    )),
                width: width,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Email", style: TextStyles.subtitle),
                      CustomTextField(
                          controller: _emailController,
                          isPassword: false,
                          onChanged: (str) {
                            setState(() {});
                          }),
                      SizedBox(height: height * 0.01),
                      const Text("Contraseña", style: TextStyles.subtitle),
                      CustomTextField(
                        isPassword: true,
                        controller: _passwordController,
                        onChanged: (str) {
                          setState(() {});
                        },
                      ),
                      SizedBox(height: height * 0.01),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CupertinoButton(
                                color: Colors.transparent,
                                padding: EdgeInsets.zero,
                                child: const Text("Olvidé mi contraseña",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Outfit",
                                        letterSpacing:
                                            BorderSide.strokeAlignInside,
                                        fontSize: 16)),
                                onPressed: () {
                                  Navigator.pushNamed(context, "/recovery");
                                })
                          ]),
                      SizedBox(height: height * 0.01),
                      CustomButton(
                          width: width,
                          height: height * 0.077,
                          onTap: () async {
                            print("Starting login");

                            // Comprobar la conexión a Internet
                            var connectivityResult =
                                await Connectivity().checkConnectivity();
                            if (connectivityResult == ConnectivityResult.none) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.black,
                                  behavior: SnackBarBehavior.floating,
                                  content: Text(
                                    "No hay conexión a Internet",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              return;
                            }

                            // Si existe conexión, continuar con el login
                            UserProvider userProvider;
                            authProvider
                                .login(_email, _password, deviceID)
                                .then((value) async {
                              print("Login response in UI: token=${value.token}, message=${value.message}, statusCode=${value.statusCode}"); // DEBUG
                              if (value.token != null && value.token != "" &&
                                  value.statusCode == 0) {
                                authProvider.isAuthenticated = true;
                                authProvider.remembermeValue = rememberMe;
                                userProvider = Provider.of<UserProvider>(context,
                                    listen: false);
                                await prefs.setString("token", value.token!);
                                // Es buena idea esperar a que getUserData complete si es crucial antes de navegar
                                await userProvider.getUserData(); 
                                await prefs.setBool("rememberMe", rememberMe);
                                await prefs.setString("deviceID", deviceID);
                                print("Moving to home");
                                Navigator.pushReplacementNamed(context, "/home"); // Usar pushReplacementNamed para que no pueda volver a login
                              } else {
                                print("Login failed in UI: message=${value.message}, statusCode=${value.statusCode}"); // DEBUG
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.black,
                                    behavior: SnackBarBehavior.floating,
                                    content: Text(
                                      value.message ?? "Error al iniciar sesión. Inténtalo de nuevo.", // Manejo de mensaje nulo
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    duration: const Duration(seconds: 3),
                                  ),
                                );
                              }
                            }).catchError((error, stackTrace) {
                              print("Error en la cadena de login Future: $error"); // DEBUG
                              print(stackTrace); // DEBUG
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.red,
                                  behavior: SnackBarBehavior.floating,
                                  content: Text(
                                    "Ocurrió un error inesperado: ${error.toString()}",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  duration: const Duration(seconds: 3),
                                ),
                              );
                            });
                          },
                          color: Colors.black,
                          labelColor: Colors.white,
                          label: "Iniciar Sesión"),
                      SizedBox(height: height * 0.02),
                      Row(
                        children: [
                          Expanded(
                              child: Container(
                                  width: width,
                                  color: Colors.black,
                                  height: 1)),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text("ó", style: TextStyle(fontSize: 16)),
                          ),
                          Expanded(
                              child: Container(
                                  width: width,
                                  color: Colors.black,
                                  height: 1)),
                        ],
                      ),
                      SizedBox(height: height * 0.02),
                      CustomButton(
                          width: width,
                          height: height * 0.08,
                          onTap: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          color: Colors.white,
                          labelColor: Colors.black,
                          label: "Registrarme"),
                    ])),
          )
        ],
      ),
    );
  }
}

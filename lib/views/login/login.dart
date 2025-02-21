import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tu_mercado/components/button.dart';
import 'package:tu_mercado/components/text_field.dart';
import 'package:tu_mercado/config/colors.dart';
import 'package:tu_mercado/config/styles.dart';
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
  late UserData _userData;

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
      rememberMe = prefs.getBool("rememberMe") ?? false;
      deviceID = prefs.getString("deviceID") ?? "void";
      print("device id: $deviceID");
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    // ignore: no_leading_underscores_for_local_identifiers
    void _onRememberMeChanged(bool? value) {
      setState(() {
        rememberMe = value!;
      });
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: height * 0.08),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              "Bienvenido",
              style: TextStyles.title,
            ),
          ),
          SizedBox(height: height * 0.08),
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
                      SizedBox(height: height * 0.03),
                      const Text("Contraseña", style: TextStyles.subtitle),
                      CustomTextField(
                        isPassword: true,
                        controller: _passwordController,
                        onChanged: (str) {
                          setState(() {});
                        },
                      ),
                      SizedBox(height: height * 0.02),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              Checkbox(
                                fillColor:
                                    const WidgetStatePropertyAll(Colors.black),
                                value: rememberMe,
                                onChanged: (value) {
                                  _onRememberMeChanged(value);
                                },
                              ),
                              const Text("Recuérdame",
                                  style: TextStyle(
                                      fontFamily: "Outfit",
                                      letterSpacing:
                                          BorderSide.strokeAlignInside,
                                      fontSize: 16))
                            ]),
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
                      SizedBox(height: height * 0.03),
                      CustomButton(
                          width: width,
                          height: height * 0.07,
                          onTap: () {
                            authProvider
                                .login(_email, _password, deviceID)
                                .then((value) async => {
                                      print(value),
                                      if (value.contains("incorrectos") ||
                                          value ==
                                              "No se ha podido conectar con el servidor, por favor revisa tu conexión a internet.")
                                        {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                              value,
                                              style: TextStyles.normal,
                                            ),
                                            backgroundColor: Colors.black,
                                          ))
                                        }
                                      else
                                        {
                                          prefs.setString("token", value),
                                          await Provider.of<UserProvider>(
                                                  context,
                                                  listen: false)
                                              .getUserData(),
                                          _userData = Provider.of<UserProvider>(
                                                  // ignore: use_build_context_synchronously
                                                  context,
                                                  listen: false)
                                              .userData,
                                          prefs.setBool("membership",
                                              _userData.membership.active),
                                          prefs.setBool("first_discount", true),
                                          prefs.setBool(
                                              "rememberMe", rememberMe),
                                          prefs.setString("email", _email),
                                          prefs.setString(
                                              "password", _password),
                                          Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              "/home",
                                              (route) => false)
                                        }
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
                          height: height * 0.07,
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

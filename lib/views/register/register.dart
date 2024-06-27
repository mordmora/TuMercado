import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tu_mercado/config/colors.dart';
import 'package:tu_mercado/config/styles.dart';
import 'package:tu_mercado/models/User.dart';
import 'package:tu_mercado/providers/auth_provider.dart';
import 'package:tu_mercado/views/register/sub_views/contact_form.dart';
import 'package:tu_mercado/views/register/sub_views/email_pass_form.dart';
import 'package:tu_mercado/views/register/sub_views/personal_form.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> with TickerProviderStateMixin {
  double page = 0;
  double pageClamp = 0;
  late SharedPreferences prefs;

  void getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();

    _pageController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _lastNameController.dispose();
    _dateController.dispose();
    _phoneController.dispose();
    _adressController.dispose();
  }

  final PageController _pageController =
      PageController(initialPage: 0, viewportFraction: 0.95);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _adressController = TextEditingController();

  String _email = "";
  String _password = "";
  String _name = "";
  String _lastName = "";
  String _date = "";
  String _phone = "";
  String _adress = "";
  int activeIndex = 0;
  // ignore: unused_field, prefer_final_fields
  bool _register_status = false;
  void pageListener() {
    setState(() {
      page = _pageController.page!;
      pageClamp = page.clamp(0, 3);
    });
  }

  @override
  void initState() {
    getSharedPreferences();
    super.initState();
    _lastNameController.addListener(() {
      _lastName = _lastNameController.text;
    });
    _nameController.addListener(() {
      _name = _nameController.text;
    });
    _phoneController.addListener(() {
      _phone = _phoneController.text;
    });
    _adressController.addListener(() {
      _adress = _adressController.text;
    });
    _dateController.addListener(() {
      _date = _dateController.text;
    });
    _emailController.addListener(() {
      _email = _emailController.text;
    });
    _passwordController.addListener(() {
      _password = _passwordController.text;
    });
    _confirmPasswordController.addListener(() {});
    _pageController.addListener(pageListener);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    List<Widget> pages = [
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 20,
        ),
        child: Container(
          padding: EdgeInsets.all(width * 0.06),
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Color(0xFFB9B9B9),
                spreadRadius: 2,
                blurRadius: 7,
                offset: Offset(-2, 1),
              )
            ],
            color: Palette.primary,
            borderRadius: BorderRadius.circular(40),
          ),
          child: EmailPassForm(
              onTap: () {
                _pageController.nextPage(
                  curve: Curves.easeInOutCubicEmphasized,
                  duration: const Duration(milliseconds: 300),
                );
              },
              emailController: _emailController,
              passwordController: _passwordController,
              confirmPasswordController: _confirmPasswordController),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Container(
          padding: EdgeInsets.all(width * 0.06),
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Color(0xFFB9B9B9),
                spreadRadius: 2,
                blurRadius: 7,
                offset: Offset(-2, 1),
              )
            ],
            color: Palette.primary,
            borderRadius: BorderRadius.circular(40),
          ),
          child: PersonalForm(
            onTap: () {
              _pageController.nextPage(
                curve: Curves.easeInOutCubicEmphasized,
                duration: const Duration(milliseconds: 300),
              );
            },
            nameController: _nameController,
            lastNameController: _lastNameController,
            dateController: _dateController,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Container(
          padding: EdgeInsets.all(width * 0.06),
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Color(0xFFB9B9B9),
                spreadRadius: 2,
                blurRadius: 7,
                offset: Offset(-2, 1),
              )
            ],
            color: Palette.primary,
            borderRadius: BorderRadius.circular(40),
          ),
          child: ContactForm(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        backgroundColor: Colors.transparent,
                        contentPadding: EdgeInsets.zero,
                        content: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text:
                                      'Al registrarte estás aceptando nuestros ',
                                  style: TextStyles.normal
                                      .copyWith(color: Colors.black),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'términos y condiciones',
                                      style: const TextStyle(
                                          color: Palette.greenDark,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Outfit',
                                          decoration: TextDecoration.underline),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {},
                                    ),
                                    const TextSpan(
                                      text: '.',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ActionsButtons(
                                    text: "Aceptar",
                                  ),
                                  ActionsButtons(
                                    text: "Cancelar",
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ));
              if (_date == "" || _phone == "" || _adress == "") {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Completa todos los campos"),
                  ),
                );
              } else if (_passwordController.text !=
                  _confirmPasswordController.text) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Las contraseñas no coinciden"),
                ));
              } else if (!_emailController.text.contains("@")) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Email invalido"),
                ));
              } else if (_passwordController.text.length < 6) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                        "La contraseña debe tener al menos 6 caracteres")));
              } else {
                User user = User(_name, _lastName, _date, _phone, _adress);
                Provider.of<AuthProvider>(context, listen: false)
                    .register(user, _email, _password)
                    .then((value) {
                  print(value);
                  if (value != "Registro completado") {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(value),
                      ),
                    );
                    _register_status = false;
                  } else {
                    _register_status = true;
                  }
                }).whenComplete(() {
                  if (_register_status) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Registro completado"),
                      ),
                    );
                    prefs.setBool("rememberMe", true);
                    prefs.setString("email", _email);
                    prefs.setString("password", _password);
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/home', (route) => false);
                  }
                });
              }
            },
            numberController: _phoneController,
            adressController: _adressController,
          ),
        ),
      )
    ];
    List<String> titles = [
      "Ingresa tu email y contraseña",
      "Información personal",
      "Información de contacto"
    ];
    //double height = MediaQuery.of(context).size.height;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                    flex: 2,
                    child: Center(
                        child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 400),
                            key: ValueKey(activeIndex),
                            child: Text(titles[activeIndex],
                                style: TextStyles.title)))),
                Expanded(
                  flex: 8,
                  child: Center(
                    child: SizedBox(
                      child: PageView(
                        physics: const ClampingScrollPhysics(),
                        onPageChanged: (value) {
                          activeIndex = value;
                          setState(() {});
                        },
                        padEnds: false,
                        controller: _pageController,
                        children: pages,
                      ),
                    ),
                  ),
                ),
                const Flexible(child: SizedBox.shrink())
              ]),
        ));
  }
}

class ActionsButtons extends StatelessWidget {
  final String text;
  const ActionsButtons({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: const ButtonStyle(
          padding:
              MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 30)),
          backgroundColor: MaterialStatePropertyAll(Colors.black),
          foregroundColor: MaterialStatePropertyAll(Colors.white),
          overlayColor: MaterialStatePropertyAll(
            Colors.transparent,
          ),
        ),
        onPressed: () {},
        child: Text(text));
  }
}

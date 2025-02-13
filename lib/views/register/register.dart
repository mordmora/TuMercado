// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

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
  bool termsAccepted = false;

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
                User user = User(_name, _lastName, _date, _phone, _adress, "");
                Provider.of<AuthProvider>(context, listen: false)
                    .register(user, _email, _password)
                    .then((value) {
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
                }).whenComplete(() async {
                  if (_register_status) {
                    await showConditionsTerms(context);
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

  Future<dynamic> showConditionsTerms(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
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
              const Text(
                'Términos y Condiciones',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Flexible(
                child: SingleChildScrollView(
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 14, color: Colors.black),
                      children: [
                        TextSpan(
                          text: '1. Aceptación de los Términos\n',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text:
                              'Al acceder y utilizar TuMercado usted acepta estar sujeto a los siguientes términos y condiciones. Si no está de acuerdo con estos términos, le solicitamos que no utilice el software.\n\n',
                        ),
                        TextSpan(
                          text: '2. Definiciones\n',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: '• Software: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text:
                              'Se refiere a TuMercado propiedad de TECHNOLOGY GLOBAL AMBIENTAL SAS que le proporciona a los usuarios acceso los componentes principales del sistema que son; un panel administrativo, aplicación de Clientes y aplicación de Domiciliarios.\n\n',
                        ),
                        TextSpan(
                          text: '• Usuario: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text:
                              'Cualquier persona que utilice el software, ya sea como usuario registrado o invitado.\n\n',
                        ),
                        TextSpan(
                          text: '• Servicios y uso de la aplicación: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text:
                              'Son todas las funcionalidades ofrecidas por el software, tales como:\n\n',
                        ),
                        TextSpan(
                          text:
                              '• El panel principal muestra datos estadísticos de los pedidos y sus respectivos estados:\n',
                        ),
                        TextSpan(
                            text:
                                '  • Pendiente\n  • Cancelado\n  • En camino\n  • Realizados\n\n'),
                        TextSpan(
                          text: '• El administrador es el encargado de:\n',
                        ),
                        TextSpan(
                            text:
                                '  • Crear productos\n  • Registrar barrios\n  • Registrar domiciliarios\n  • Registrar bodegas\n\n'),
                        TextSpan(
                          text: '3. Licencia de Uso\n',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text:
                              'El software se proporciona bajo una licencia limitada, no exclusiva, intransferible para su uso personal o comercial, de acuerdo con las condiciones aquí establecidas. Queda prohibido:\n',
                        ),
                        TextSpan(
                            text:
                                '• Modificar, adaptar o descompilar el software.\n• Redistribuir, vender o transferir el software a terceros sin autorización.\n• Utilizar el software para fines ilegales o no permitidos por estos términos.\n\n'),
                        TextSpan(
                          text: '4. Registro de Usuario\n',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text:
                              'Al crear una cuenta o registrar el uso del software, el usuario deberá proporcionar información personal exacta y actualizada. Usted es responsable de mantener la confidencialidad de su cuenta y contraseña.\n\n',
                        ),
                        TextSpan(
                          text: '5. Protección de Datos Personales\n',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text:
                              'El tratamiento de sus datos personales está sujeto a la Ley 1581 de 2012 y la Política de Privacidad del software. Al utilizar el software, usted autoriza el tratamiento de sus datos conforme a la política mencionada. Los datos recopilados pueden incluir, entre otros, su nombre, correo electrónico y otros datos necesarios para la prestación del servicio.\n\n',
                        ),
                        TextSpan(
                          text: '6. Propiedad Intelectual\n',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text:
                              'El software, su código fuente, interfaz, diseño y contenido son propiedad exclusiva de TECHNOLOGY GLOBAL AMBIENTAL SAS y están protegidos por las leyes de propiedad intelectual de Colombia. El usuario no adquiere ningún derecho sobre el software más allá de la licencia de uso otorgada.\n\n',
                        ),
                        TextSpan(
                          text: '7. Responsabilidad\n',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text:
                              'El software se proporciona "tal cual", sin garantías de ningún tipo, explícitas o implícitas.\nTECHNOLOGY GLOBAL AMBIENTAL no será responsable por daños directos, indirectos, incidentales, especiales o consecuentes derivados del uso del software, incluidos daños a dispositivos electrónicos o pérdida de datos.\n\n',
                        ),
                        TextSpan(
                          text: '8. Modificaciones\n',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text:
                              'TECHNOLOGY GLOBAL AMBIENTAL se reserva el derecho de modificar estos términos y condiciones en cualquier momento, sin previo aviso. Cualquier modificación será efectiva una vez publicada en la página web o plataforma del software. Es responsabilidad del usuario revisar periódicamente estos términos.\n\n',
                        ),
                        TextSpan(
                          text: '9. Duración y Terminación\n',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text:
                              'La licencia de uso del software tiene una duración indefinida, salvo que se rescinda por alguna de las partes. El usuario puede cancelar su cuenta en cualquier momento. TECHNOLOGY GLOBAL AMBIENTAL podrá suspender o terminar la cuenta de un usuario por incumplimiento de estos términos.\n\n',
                        ),
                        TextSpan(
                          text: '10. Ley Aplicable y Jurisdicción\n',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text:
                              'Estos términos y condiciones se regirán por las leyes de la República de Colombia. Cualquier disputa relacionada con el uso del software será resuelta ante los tribunales competentes de Santa Marta.',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                        context, '/login', (route) => false),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Aceptar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ActionsButtons extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  const ActionsButtons({
    super.key,
    this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: const ButtonStyle(
          padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 30)),
          backgroundColor: WidgetStatePropertyAll(Colors.black),
          foregroundColor: WidgetStatePropertyAll(Colors.white),
          overlayColor: WidgetStatePropertyAll(
            Colors.transparent,
          ),
        ),
        onPressed: onPressed,
        child: Text(text));
  }
}

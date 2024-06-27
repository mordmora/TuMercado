import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tu_mercado/components/edit_attribute.dart';
import 'package:tu_mercado/config/styles.dart';
import 'package:tu_mercado/models/user_data.dart';
import 'package:tu_mercado/providers/user_data_provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String _password = "";
  String _address = "";
  String _phone = "";

  void initState() {
    _phoneController.addListener(() {
      _phone = _phoneController.text;
    });
    _passwordController.addListener(() {
      _password = _passwordController.text;
    });
    _addressController.addListener(() {
      _address = _addressController.text;
    });
    super.initState();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text(
            "Editar perfil",
            style: TextStyles.title,
          ),
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<UserProvider>(
            builder: (BuildContext context, UserProvider value, Widget? child) {
              _phoneController.text = value.userData.phone;
              _addressController.text = value.userData.address;

              UserData userData = value.userData;
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EditAttribute(
                      label: userData.firstName,
                      editable: false,
                    ),
                    const SizedBox(height: 20),
                    EditAttribute(
                      label: userData.email,
                      editable: false,
                    ),
                    const SizedBox(height: 20),
                    EditAttribute(
                        formatter: [FilteringTextInputFormatter.digitsOnly],
                        keyboardType: TextInputType.number,
                        label: userData.phone,
                        controller: _phoneController),
                    const SizedBox(height: 20),
                    EditAttribute(
                        editable: true,
                        label: userData.address,
                        controller: _addressController),
                    const SizedBox(height: 10),
                    const Text(
                      "Recuerda que por el momento solo funcionamos en Santa Marta.",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'Outfit',
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      child: TextButton(
                          style: TextButton.styleFrom(
                            enableFeedback: false,
                            //splashFactory: NoSplash.splashFactory,
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.black,
                          ),
                          onPressed: () {},
                          child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Quieres cambiar tu contraseña?",
                                style: TextStyles.profileName,
                                textAlign: TextAlign.start),
                          )),
                    ),
                    const Spacer(),
                    Center(
                        child: CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              Provider.of<UserProvider>(context, listen: false)
                                  .updateProfile(_phone, _address, _password)
                                  .then((value) {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          content: Text("Cuenta actualizada"),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator
                                                      .pushNamedAndRemoveUntil(
                                                          context,
                                                          "/home",
                                                          (route) => false);
                                                },
                                                child: const Text("Ok"))
                                          ],
                                        ));
                              }).onError((error, stackTrace) => showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            content: Text(error.toString()),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("Ok"))
                                            ],
                                          )));
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              width: 300,
                              height: 50,
                              child: const Text("Guardar cambios",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: 'Outfit',
                                  ),
                                  textAlign: TextAlign.center),
                            ))),
                  ]);
            },
          ),
        )));
  }
}

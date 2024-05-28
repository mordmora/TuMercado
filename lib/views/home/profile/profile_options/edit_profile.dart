import 'package:flutter/material.dart';
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
                        label: userData.phone, controller: _phoneController),
                    const SizedBox(height: 20),
                    EditAttribute(
                        label: userData.address,
                        controller: _addressController),
                    const SizedBox(height: 20),
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
                    Spacer(),
                    Center(
                      child: FloatingActionButton(
                          onPressed: () {}, child: Icon(Icons.save)),
                    ),
                  ]);
            },
          ),
        )));
  }
}

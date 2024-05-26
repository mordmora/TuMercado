import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tu_mercado/components/action_card.dart';
import 'package:tu_mercado/components/row_info.dart';
import 'package:tu_mercado/models/user_data.dart';
import 'package:tu_mercado/providers/user_data_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late UserData userData;
  late SharedPreferences prefs;

  @override
  void initState() {
    getSharedPreferences();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future:
              Provider.of<UserProvider>(context, listen: false).getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Consumer<UserProvider>(
                  builder: (context, UserProvider userProvider, _) {
                userData = userProvider.userData;
                return ListView(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: CircleAvatar(
                              radius: 80,
                              child: Icon(Icons.person, size: 85),
                            ),
                          ),
                          const SizedBox(height: 20),
                          RowInfo(label: "Nombre", content: userData.firstName),
                          RowInfo(label: "Email", content: userData.email),
                          const SizedBox(height: 40),
                          ActionCard(
                              label: "Pedidos en progreso",
                              icon: Icons.list,
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed('/user/order_progress');
                              }),
                          ActionCard(
                            label: "Editar perfil",
                            icon: Icons.edit,
                            onTap: () {
                              Navigator.of(context).pushNamed('/user/edit');
                            },
                          ),
                          ActionCard(
                            label: "Cambiar contraseña",
                            icon: Icons.password,
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed('/user/change_pwd');
                            },
                          ),
                          ActionCard(
                              label: "Historial de compras",
                              icon: Icons.history,
                              onTap: () {}),
                          ActionCard(
                            label: "Cerrar sesión",
                            icon: Icons.logout,
                            onTap: () {
                              print("cerrar sesion");
                              prefs.clear();
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  "/", (route) => false);
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                );
              });
            }
          },
        ),
      ),
    );
  }
}

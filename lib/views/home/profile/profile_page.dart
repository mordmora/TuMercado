import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tu_mercado/components/action_card.dart';
import 'package:tu_mercado/components/row_info.dart';
import 'package:tu_mercado/models/user_data.dart';
import 'package:tu_mercado/providers/user_data_provider.dart';
import 'package:tu_mercado/utils.dart';

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

  Future<void> openWhatsappSupportLink() async {
    launchUrl(Uri.parse(WHATSAPP_URL),
        customTabsOptions: const CustomTabsOptions(
          shareState: CustomTabsShareState.on,
        ));
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
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
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
                          RowInfo(
                              label: "Plan",
                              content: userData.membership.active
                                  ? "Premium"
                                  : "Normal"),
                          const SizedBox(height: 20),
                          ActionCard(
                              label: "Mis pedidos",
                              icon: Icons.list,
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed('/user/my_orders');
                              }),
                          ActionCard(
                            label: "Editar perfil",
                            icon: Icons.edit,
                            onTap: () {
                              Navigator.of(context).pushNamed('/user/edit');
                            },
                          ),
                          ActionCard(
                              label: "Comunicate con soporte",
                              icon: Icons.help,
                              onTap: () {
                                openWhatsappSupportLink();
                              }),
                          ActionCard(
                              label: "Actualizar plan",
                              icon: Icons.data_exploration_rounded,
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  '/premium_offer',
                                  arguments: {
                                    'callback': () {
                                      Navigator.pop(context);
                                    },
                                    'isActive': userData.membership.active
                                        ? true
                                        : false,
                                  },
                                );
                              }),
                          ActionCard(
                            label: "Cerrar sesión",
                            icon: Icons.logout,
                            onTap: () {
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

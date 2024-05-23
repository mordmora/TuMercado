import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
                          ActionCard(),
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

import 'package:flutter/material.dart';
import 'package:tu_mercado/config/styles.dart';

class ActionCard extends StatefulWidget {
  const ActionCard({super.key});

  @override
  State<ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<ActionCard> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        height: 1,
        color: Colors.grey,
      ),
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Editar perfil", style: TextStyles.subtitle),
            IconButton(onPressed: () {}, icon: const Icon(Icons.edit))
          ],
        ),
      )
    ]);
  }
}

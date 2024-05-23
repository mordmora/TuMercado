import 'package:flutter/material.dart';
import 'package:tu_mercado/config/styles.dart';

class ActionCard extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const ActionCard(
      {super.key,
      required this.label,
      required this.icon,
      required this.onTap});

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
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.label, style: TextStyles.subtitle),
            IconButton(onPressed: widget.onTap, icon: Icon(widget.icon))
          ],
        ),
      )
    ]);
  }
}

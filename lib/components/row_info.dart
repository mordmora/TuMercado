import 'package:flutter/material.dart';
import 'package:tu_mercado/config/styles.dart';

class RowInfo extends StatelessWidget {
  const RowInfo({
    super.key,
    required this.label,
    required this.content,
  });

  final String label;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyles.profileText,
        ),
        Text(
          content,
          style: TextStyles.profileName,
        ),
      ],
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final void Function() onTap;
  final double width;
  final double height;
  final String label;
  final Color labelColor;
  final Color color;
  const CustomButton(
      {super.key,
      required this.onTap,
      required this.color,
      required this.labelColor,
      required this.width,
      required this.height,
      required this.label});

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(40),
        ),
        child: CupertinoButton(
            onPressed: widget.onTap,
            child: Text(widget.label,
                style: TextStyle(
                    color: widget.labelColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Outfit'))));
  }
}

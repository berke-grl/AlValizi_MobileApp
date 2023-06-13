import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  const FollowButton(
      {super.key,
      required this.text,
      required this.function,
      required this.bgColor,
      required this.borderColor});
  final String text;
  final Color bgColor;
  final Color borderColor;
  final Function()? function;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 4),
      child: TextButton(
        onPressed: function,
        child: Container(
          decoration: BoxDecoration(
              color: bgColor,
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(4)),
          alignment: Alignment.center,
          width: 200,
          height: 25,
          child: Text(
            text,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

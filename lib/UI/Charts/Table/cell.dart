import 'package:flutter/material.dart';

class Cell extends StatelessWidget{
  const Cell({super.key, required this.switcher});
  final bool switcher;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        switcher? Icons.check_rounded:Icons.close_rounded,
        color: switcher? Colors.green:Colors.red,
      )
    );
  }
}
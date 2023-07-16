import 'package:flutter/material.dart';

class BlankPixel extends StatelessWidget {
  const BlankPixel({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[800], borderRadius: BorderRadius.circular(4)),
      ),
    );
  }
}

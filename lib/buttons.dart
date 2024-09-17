import 'package:flutter/material.dart';

class Buttons extends StatelessWidget {
  final String text;

  Buttons({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            // Handle button press
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xff2e73ae),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

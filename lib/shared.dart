import 'package:flutter/material.dart';

Widget actionButton({
  required String text,
  onPressed,
  isLoading = false,
  double margin =0,
}) =>
    Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: margin),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade800),
        onPressed: onPressed,
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                text,
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
      ),
    );

import 'package:flutter/material.dart';

InputDecoration paymentInputDecoration({
  required String hint,
  Widget? suffixIcon,
}) {
  return InputDecoration(
    hintText: hint,
    suffixIcon: suffixIcon,

    filled: true,
    fillColor: const Color(0xfff1f5f9),

    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 18,
    ),

    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),

    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),

    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(
        color: Color(0xff137fec),
        width: 1.5,
      ),
    ),
  );
}
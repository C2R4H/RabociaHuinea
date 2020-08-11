import 'package:flutter/material.dart';

InputDecoration textfielddecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        ),
    labelStyle: TextStyle(
        color: Colors.black,
    ),
  );
}

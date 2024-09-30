import 'package:flutter/material.dart';

const kTextFormFieldDecoration = InputDecoration(
  labelStyle: TextStyle(
    fontSize: 18,
    color: Colors.black54,
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10),
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black),
    borderRadius: BorderRadius.all(
      Radius.circular(10),
    ),
  ),
);

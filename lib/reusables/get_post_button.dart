import 'package:flutter/material.dart';

class GetPostButton extends StatelessWidget {
  final Future<void> Function()? onPressed;
  final String buttonText;

  const GetPostButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Material(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(15.0),
        child: MaterialButton(
          onPressed: onPressed != null
              ? () async {
                  await onPressed!();
                }
              : null,
          minWidth: double.infinity,
          height: 50.0,
          child: Text(
            buttonText,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

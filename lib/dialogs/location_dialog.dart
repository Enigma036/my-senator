import 'package:flutter/material.dart';

class LocationDialog extends StatelessWidget {
  LocationDialog({super.key, this.title, this.text});

  final title;
  final text;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(text),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: const Text('OK', style: TextStyle(color: Color(0xff003876))),
        ),
      ],
    );
  }
}

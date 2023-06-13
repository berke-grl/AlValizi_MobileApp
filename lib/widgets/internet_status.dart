import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InternetStatus extends StatelessWidget {
  const InternetStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('No Internet Connection'),
      content: const Text('Please Check Your Internet Connection'),
      actions: <Widget>[
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => SystemNavigator.pop(),
            child: const Text('Exit'),
          ),
        ),
      ],
    );
  }
}

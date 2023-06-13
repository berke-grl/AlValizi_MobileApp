import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class TranslateResultScreen extends StatefulWidget {
  final String text;
  const TranslateResultScreen({super.key, required this.text});

  @override
  State<TranslateResultScreen> createState() => _TranslateResultScreenState();
}

class _TranslateResultScreenState extends State<TranslateResultScreen> {
  String translated = "Translation";

  Future<void> _translateText(String text) async {
    final translation = await text.translate(
      from: 'auto', //Detect language
      to: 'tr',
    );
    setState(() {
      translated = translation.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Result"),
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.green,
      body: Card(
        margin: const EdgeInsets.all(12),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              "English(US)",
            ),
            const SizedBox(height: 8),
            Container(
              child: Text(widget.text),
            ),
            const Divider(height: 32),
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.greenAccent,
              child: IconButton(
                  onPressed: () async {
                    await _translateText(widget.text);
                  },
                  icon: const Icon(Icons.translate),
                  color: Colors.green,
                  highlightColor: Colors.amberAccent),
            ),
            Text(
              translated,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

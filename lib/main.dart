import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {},
            ),
          ],
          title: Text('Weather App'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Placeholder(
                fallbackHeight: 200,
              ),
              const SizedBox(height: 10),
              Placeholder(
                fallbackHeight: 200,
              ),
              const SizedBox(height: 10),
              Placeholder(
                fallbackHeight: 200,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

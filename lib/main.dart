import 'dart:math';

import 'package:beautiful_pie/pie/data.dart';
import 'package:beautiful_pie/pie/main.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Beautiful Pie'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final data = const PieChartData(
    sections: [
      PieSection(
        value: 0.25,
        color: Colors.blue,
        label: 'Red',
        offset: Offset(0, 0),
      ),
      PieSection(
        value: 0.25,
        color: Colors.green,
        label: 'Green',
        offset: Offset(0, 0),
        selected: true,
      ),
      PieSection(
        value: 0.5,
        color: Colors.red,
        label: 'Blue',
        offset: Offset(0, 0),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
          title: Center(
            child: Text(widget.title),
          )),
      body: Center(
        child: SizedBox.square(
          dimension: min(MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height) *
              0.8,
          child: AnimatedPieChart(data: data),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.brush_rounded), label: 'Paint'),
        ],
      ),
    );
  }
}

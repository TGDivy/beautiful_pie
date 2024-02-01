import 'dart:math';

import 'package:beautiful_pie/event_chart/data.dart';
import 'package:beautiful_pie/event_chart/main.dart';
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

final now = DateTime.now();

class _MyHomePageState extends State<MyHomePage> {
  final List<Event> events = [
    // Event(
    //     title: 'Event 1',
    //     time: DateTime.now(),
    //     duration: const Duration(hours: 6),
    //     color: Colors.red),
    // Event(
    //     title: 'Event 2',
    //     time: DateTime.now().add(const Duration(hours: 1)),
    //     duration: const Duration(hours: 1),
    //     color: Colors.green),
    // Event(
    //     title: 'Event 3',
    //     time: DateTime.now().add(const Duration(hours: 3)),
    //     duration: const Duration(hours: 1),
    //     color: Colors.blue),
    // Event(
    //     title: 'Event 3',
    //     time: DateTime.now().add(const Duration(hours: 5)),
    //     duration: const Duration(hours: 3),
    //     color: Colors.yellow),

    // actual events that actually make sense for my schedule
    Event(
        title: 'Sleep for a long time',
        time: DateTime(now.year, now.month, now.day, 23, 0),
        duration: const Duration(hours: 8),
        color: Colors.blueGrey),
    Event(
        title: 'Get ready',
        // time: TimeOfDay(hour: 7, minute: 30),
        time: DateTime(now.year, now.month, now.day, 7, 30),
        duration: const Duration(hours: 1),
        color: Colors.blueGrey),
    Event(
        title: 'Breakfast',
        // time: TimeOfDay(hour: 8, minute: 30),
        time: DateTime(now.year, now.month, now.day, 8, 30),
        duration: const Duration(hours: 1),
        color: Colors.green.shade200),
    Event(
        title: 'School',
        // time: TimeOfDay(hour: 7, minute: 30),
        time: DateTime(now.year, now.month, now.day, 7, 30),
        duration: const Duration(hours: 8),
        color: Colors.blue.shade300),
  ];

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
          child: EventsChart(events: events),
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

import 'package:flutter/material.dart';

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int count = 0;
  void increment() {
    setState(() {
      count++;
    });
  }

  void decrement() {
    setState(() {
      if (count > 0) {
        count--;
      }
    });
  }

  void reset() {
    setState(() {
      count = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('Вы нажали: $count раз', style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: increment,
              child: const Text('Увеличить'),
            ),
            ElevatedButton(
              onPressed: decrement,
              child: const Text('Уменьшить'),
            ),
            ElevatedButton(
              onPressed: reset,
              child: const Text('Обнулить'),
            ),
          ],
        ),
      ),
    );
  }
}

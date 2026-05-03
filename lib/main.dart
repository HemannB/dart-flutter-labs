import 'package:flutter/material.dart';
import 'package:questlog/core/theme.dart';

void main() {
  runApp(const QuestLogApp());
}

class QuestLogApp extends StatelessWidget {
  const QuestLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuestLog',
      theme: AppTheme.dark,
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('⚔️', style: TextStyle(fontSize: 64)),
              SizedBox(height: 16),
              Text(
                'QuestLog',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'building...',
                style: TextStyle(color: Color(0xFF7A7A9A), fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
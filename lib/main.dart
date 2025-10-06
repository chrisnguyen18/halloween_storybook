import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spooky Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF6A00),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: '🎃 Spooky Home Page'),
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
  int _treats = 0;

  void _showBoo(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const AlertDialog(
        content: Text('Boo! Got you!', textAlign: TextAlign.center),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), centerTitle: true),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A0F1F), Color(0xFF0E0712)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Chip(
                  avatar: const Text('🍬', style: TextStyle(fontSize: 18)),
                  label: Text('Treats: $_treats'),
                ),
                const SizedBox(width: 20),
                const Chip(
                  label: Text('Tap 🎃 for treats, avoid 👻'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Stack(
                children: [
                  // Floating emojis
                  Positioned.fill(
                    child: FloatyEmoji(
                      '🎃',
                      size: 50,
                      durationMs: 3000,
                      onTap: () => setState(() => _treats += 1),
                    ),
                  ),
                  Positioned.fill(
                    child: FloatyEmoji('🎃', size: 50, durationMs: 3300, onTap: () => setState(() => _treats += 1)),
                  ),
                  Positioned.fill(
                    child: FloatyEmoji('🎃', size: 46, durationMs: 3400, onTap: () => setState(() => _treats += 1)),
                  ),
                  Positioned.fill(
                    child: FloatyEmoji('🎃', size: 42, durationMs: 3200, onTap: () => setState(() => _treats += 1)),
                  ),

                  Positioned.fill(child: FloatyEmoji('👻', size: 46, durationMs: 3100, onTap: () => _showBoo(context))),
                  Positioned.fill(child: FloatyEmoji('👻', size: 42, durationMs: 3000, onTap: () => _showBoo(context))),
                  Positioned.fill(child: FloatyEmoji('👻', size: 49, durationMs: 3100, onTap: () => _showBoo(context))),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

/// Picks a random Alignment target; when the animation ends, it picks another.
class FloatyEmoji extends StatefulWidget {
  final String emoji;
  final double size;
  final int durationMs;
  final VoidCallback? onTap;

  const FloatyEmoji(
    this.emoji, {
    super.key,
    this.size = 40,
    this.durationMs = 1800,
    this.onTap,
  });

  @override
  State<FloatyEmoji> createState() => _FloatyEmojiState();
}

class _FloatyEmojiState extends State<FloatyEmoji> {
  static final _rand = Random();
  Alignment _target = _randAlign();

  static Alignment _randAlign() {
    double r() => (_rand.nextDouble() * 1.8) - 0.9;
    return Alignment(r(), r());
  }

  @override
  void initState() {
    super.initState();
    // Start somewhere random, then immediately move to a new target:
    _target = _randAlign();
    // Picks a new target on first frame for variety.
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() => _target = _randAlign()));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      alignment: _target,
      duration: Duration(milliseconds: widget.durationMs),
      curve: Curves.easeInOut,
      onEnd: () => setState(() => _target = _randAlign()),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Text(widget.emoji, style: TextStyle(fontSize: widget.size)),
      ),
    );
  }
}

import 'dart:async';
import 'package:apotik_online/core/color/colors.dart';
import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<StatefulWidget> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  Timer? _timer;
  String text = '.';

  @override
  void initState() {
    super.initState();
    animation();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Hentikan timer sebelum widget dibuang
    super.dispose();
  }

  void animation() {
    _timer = Timer.periodic(const Duration(milliseconds: 250), (_) {
      if (!mounted) return;
      setState(() {
        text = text.length < 5 ? '$text.' : '.';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/logo/loading.png',
              width: 120,
            ),
            const SizedBox(height: 20),
            Text(
              "Please wait $text",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

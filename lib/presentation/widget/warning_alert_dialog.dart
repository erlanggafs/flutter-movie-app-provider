import 'package:flutter/material.dart';

// Widget untuk animasi ikon warning
class AnimatedWarningIcon extends StatefulWidget {
  @override
  _AnimatedWarningIconState createState() => _AnimatedWarningIconState();
}

class _AnimatedWarningIconState extends State<AnimatedWarningIcon>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Membuat controller animasi untuk memutar ikon
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    // Membuat animasi untuk ikon (bergetar)
    _animation = Tween<double>(begin: 10, end: 0.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticInOut),
    );

    // Menjalankan animasi saat widget ditampilkan
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value), // Menggeser posisi vertikal
          child: Icon(
            Icons.warning,
            color: Colors.red,
            size: 50,
          ),
        );
      },
    );
  }
}

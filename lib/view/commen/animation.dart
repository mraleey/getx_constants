import 'package:flutter/material.dart';
import 'package:getx_constants/constants/colors.dart';

class AnimatedBar extends StatefulWidget {
  const AnimatedBar({super.key});

  @override
  AnimatedBarState createState() => AnimatedBarState();
}

class AnimatedBarState extends State<AnimatedBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation1;
  late Animation<double> _animation2;
  late Animation<double> _animation3;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animation1 = Tween<double>(begin: 0.1, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.0,
          0.5,
          curve: Curves.easeInOut,
        ),
      ),
    );
    _animation2 = Tween<double>(begin: 0.1, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.2,
          0.7,
          curve: Curves.easeInOut,
        ),
      ),
    );
    _animation3 = Tween<double>(begin: 0.1, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.4,
          0.9,
          curve: Curves.easeInOut,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildBar(_animation1),
        const SizedBox(width: 4),
        _buildBar(_animation2),
        const SizedBox(width: 4),
        _buildBar(_animation3),
      ],
    );
  }

  Widget _buildBar(Animation<double> animation) {
    return ScaleTransition(
      scale: animation,
      child: Container(
        width: 10,
        height: 30,
        color: AppColor.primaryTheme,
      ),
    );
  }
}

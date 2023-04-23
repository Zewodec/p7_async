import 'package:flutter/material.dart';

class ColorButton extends StatefulWidget {
  final AnimationController controller;
  final VoidCallback onPress;

  const ColorButton({Key? key, required this.controller, required this.onPress})
      : super(key: key);

  @override
  State<ColorButton> createState() => _ColorButtonState();
}

class _ColorButtonState extends State<ColorButton>
    with SingleTickerProviderStateMixin {
  // late AnimationController _controller;
  late Animation<Color?> _animation;

  @override
  void initState() {
    super.initState();
    _animation = ColorTween(begin: Colors.green, end: Colors.red)
        .animate(widget.controller)
      ..addListener(() {
        setState(() {});
      });

    widget.controller.forward();
  }

  // @override
  // void dispose() {
  //   widget.controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPress,
      style: ElevatedButton.styleFrom(backgroundColor: _animation.value),
      child: const Text('Get Weather'),
    );
  }
}

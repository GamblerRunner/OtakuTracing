import 'package:flutter/material.dart';

class AnimatedFavouriteButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isInitiallyFavoured;

  AnimatedFavouriteButton({required this.onPressed, required this.isInitiallyFavoured});

  @override
  _AnimatedFavouriteButtonState createState() => _AnimatedFavouriteButtonState();
}

class _AnimatedFavouriteButtonState extends State<AnimatedFavouriteButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _sizeAnimation;
  late bool isFavoured;

  @override
  void initState() {
    super.initState();
    isFavoured = widget.isInitiallyFavoured;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _colorAnimation = ColorTween(
      begin: Colors.grey,
      end: Colors.red,
    ).animate(_controller);
    _sizeAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 30.0, end: 50.0), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 50.0, end: 30.0), weight: 50),
    ]).animate(_controller);

    if (isFavoured) {
      _controller.forward();
    }
  }

  void _handleTap() {
    setState(() {
      isFavoured = !isFavoured;
      isFavoured ? _controller.forward() : _controller.reverse();
      widget.onPressed();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Icon(
            Icons.favorite,
            color: _colorAnimation.value,
            size: _sizeAnimation.value,
          );
        },
      ),
    );
  }
}

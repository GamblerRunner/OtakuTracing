import 'package:flutter/material.dart';

/// An animated favorite button that changes size and color when pressed
class AnimatedFavouriteButton extends StatefulWidget {
  final VoidCallback onPressed;

  final bool isInitiallyFavoured;

  AnimatedFavouriteButton({required this.onPressed, required this.isInitiallyFavoured});

  @override
  AnimatedFavouriteButtonState createState() => AnimatedFavouriteButtonState();
}

/// Manages the logic and animations for the favorite button.
class AnimatedFavouriteButtonState extends State<AnimatedFavouriteButton> with SingleTickerProviderStateMixin {
  late AnimationController controller;

  late Animation<Color?> colorAnimation;

  late Animation<double> sizeAnimation;

  late bool isFavoured;

  @override
  void initState() {
    super.initState();
    // Initialize the favored state.
    isFavoured = widget.isInitiallyFavoured;

    // Set up the animation controller.
    controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Define the color animation.
    colorAnimation = ColorTween(
      begin: Colors.grey,
      end: Colors.red,
    ).animate(controller);

    // Define the size animation.
    sizeAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 30.0, end: 50.0), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 50.0, end: 30.0), weight: 50),
    ]).animate(controller);

    // If the button is initially favored, start the animation.
    if (isFavoured) {
      controller.forward();
    }
  }

  //Handles the logic when the button is pressed
  void _handleTap() {
    setState(() {
      // Toggle the favored state.
      isFavoured = !isFavoured;
      // Play the animation based on the new state.
      isFavoured ? controller.forward() : controller.reverse();
      // Call the provided onPressed callback.
      widget.onPressed();
    });
  }

  @override
  void dispose() {
    // Dispose the animation controller
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Icon(
            Icons.favorite,
            color: colorAnimation.value,
            size: sizeAnimation.value,
          );
        },
      ),
    );
  }
}

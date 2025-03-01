import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class DuckRaceGame extends FlameGame {
  static const int duckFrames = 15; // The number of frames in the duck sprite sheet.
  late SpriteAnimationComponent duck;
  late ParallaxComponent backgroundParallax;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Load the parallax scrolling backgrounds
    backgroundParallax = await loadParallaxComponent(
      [
        ParallaxImageData('game_assets/BG1(440x246).png'),
        ParallaxImageData('game_assets/BG2(440x246).png'),
        ParallaxImageData('game_assets/BG3(440x246).png'),
        ParallaxImageData('game_assets/BG4(440x246).png'),
        ParallaxImageData('game_assets/BG5(440x246).png'),
        ParallaxImageData('game_assets/BG6(440x246).png'),
      ],
      baseVelocity: Vector2(10, 0),  // Moves the background to the left
      velocityMultiplierDelta: Vector2(1.2, 0),
      repeat: ImageRepeat.repeatX,
    );

    add(backgroundParallax);

    // Load the duck sprite sheet
    final duckSheet = await images.load('game_assets/duck(15FPS).png');
    final frameWidth = duckSheet.width / duckFrames;
    final frameHeight = duckSheet.height.toDouble();

    // Create the sprite animation
    final spriteSheet = SpriteSheet(
      image: duckSheet,
      srcSize: Vector2(frameWidth, frameHeight),
    );

    final duckAnimation = spriteSheet.createAnimation(
      row: 0,
      from: 0,
      to: duckFrames - 1,
      stepTime: 0.066, // 15 FPS
    );

    // Create the duck component
    duck = SpriteAnimationComponent(
      animation: duckAnimation,
      size: Vector2(50, 50),
      position: Vector2(50, size.y * 0.65),  // Start position
    );

    add(duck);
  }

  /// Method to move the duck forward when the player gets a correct answer
  void moveDuckForward() {
    duck.position.x += 20; // Move the duck forward
  }
}

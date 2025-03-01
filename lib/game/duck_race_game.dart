import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class DuckRaceGame extends FlameGame {
  static const int duckFrames = 15;

  // Instead of "late", we assign default empty components to avoid LateInitializationError
  SpriteAnimationComponent userDuck = SpriteAnimationComponent();
  SpriteAnimationComponent opponentDuck1 = SpriteAnimationComponent();
  SpriteAnimationComponent opponentDuck2 = SpriteAnimationComponent();

  // Parallax for background
  ParallaxComponent? backgroundParallax;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // 1) Parallax background
    backgroundParallax = await loadParallaxComponent(
      [
        ParallaxImageData('game_assets/BG1(440x246).png'),
        ParallaxImageData('game_assets/BG2(440x246).png'),
        ParallaxImageData('game_assets/BG3(440x246).png'),
        ParallaxImageData('game_assets/BG4(440x246).png'),
        ParallaxImageData('game_assets/BG5(440x246).png'),
        ParallaxImageData('game_assets/BG6(440x246).png'),
      ],
      baseVelocity: Vector2(10, 0), // Moves background to the left
      velocityMultiplierDelta: Vector2(1.2, 0),
      repeat: ImageRepeat.repeatX,
    );
    add(backgroundParallax!);

    // 2) Load the duck sprite sheet
    final duckSheet = await images.load('game_assets/duck(15FPS).png');
    final frameWidth = duckSheet.width / duckFrames;
    final frameHeight = duckSheet.height.toDouble();

    final spriteSheet = SpriteSheet(
      image: duckSheet,
      srcSize: Vector2(frameWidth, frameHeight),
    );

    final duckAnimation = spriteSheet.createAnimation(
      row: 0,
      from: 0,
      to: duckFrames - 1,
      stepTime: 0.066, // ~15 FPS
    );

    // 3) Create the 3 ducks at different vertical positions near the bottom
    userDuck
      ..animation = duckAnimation
      ..size = Vector2(50, 50)
      ..position = Vector2(55, size.y * 0.7);

    opponentDuck1
      ..animation = duckAnimation
      ..size = Vector2(50, 50)
      ..position = Vector2(55, size.y * 0.6);

    opponentDuck2
      ..animation = duckAnimation
      ..size = Vector2(50, 50)
      ..position = Vector2(55, size.y * 0.5);

    add(userDuck);
    add(opponentDuck1);
    add(opponentDuck2);
  }

  /// Moves the user's duck forward
  void moveUserDuckForward() {
    userDuck.position.x += 20;
  }

  /// Optionally move opponents if you have real-time data
  void moveOpponentDuck1Forward() {
    opponentDuck1.position.x += 20;
  }

  void moveOpponentDuck2Forward() {
    opponentDuck2.position.x += 20;
  }

  // Keep ducks in the river if the screen size changes
  @override
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);
    // Re-position them to keep the same "lanes"
    userDuck.position = Vector2(55, canvasSize.y * 0.7);
    opponentDuck1.position = Vector2(55, canvasSize.y * 0.6);
    opponentDuck2.position = Vector2(55, canvasSize.y * 0.5);
  }
}

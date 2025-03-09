import 'dart:math' as math; // for math.pow
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class DuckRaceGame extends FlameGame {
  static const int duckFrames = 15;

  // Ducks
  SpriteAnimationComponent? duck1;
  SpriteAnimationComponent? duck2;
  SpriteAnimationComponent? duck3;

  // Labels for each duck (player name)
  TextComponent? duck1Label;
  TextComponent? duck2Label;
  TextComponent? duck3Label;

  // Which player is assigned to each duck
  String? duck1PlayerId;
  String? duck2PlayerId;
  String? duck3PlayerId;

  // Background
  ParallaxComponent? backgroundParallax;

  // Start/Finish lines
  SpriteComponent? startLine;
  SpriteComponent? finishLine;

  // We'll store base positions for lines
  double startLineBaseX = 60; // Where you want the Start line on-screen initially
  double startLineBaseY = 0;  // We'll set it in onLoad
  double finishLineBaseX = 60; // Where you want the Finish line off-screen initially
  double finishLineBaseY = 0;  // We'll set it in onLoad

  // We'll track how much the water layer has scrolled horizontally
  double waveScrollX = 0;
  double waterSpeedX = 0;

  // If we want the Finish line to scroll in from the right after some event,
  // we can use this flag.
  bool startFinishLineScrolling = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // 1) Parallax background
    backgroundParallax = await loadParallaxComponent(
      [
        ParallaxImageData('game_assets/BG1(440x246).png'), // layer 0
        ParallaxImageData('game_assets/BG2(440x246).png'), // layer 1
        ParallaxImageData('game_assets/BG3(440x246).png'), // layer 2
        ParallaxImageData('game_assets/BG4(440x246).png'), // layer 3
        ParallaxImageData('game_assets/BG5(440x246).png'), // layer 4 = WATER
        ParallaxImageData('game_assets/BG6(440x246).png'), // layer 5
      ],
      baseVelocity: Vector2(10, 0),
      velocityMultiplierDelta: Vector2(1.2, 0),
      repeat: ImageRepeat.repeatX,
    )..priority = -1; // behind everything
    add(backgroundParallax!);

    // 2) Calculate the water layer’s horizontal speed
    //    The water is layer index=4 => speed = baseVelocity.x * (1.2^4)
    waterSpeedX = 10 * math.pow(1.2, 4).toDouble(); // ~ 20.736

    // 3) Create Start/Finish lines (priority=0)
    final startSprite = await loadSprite('game_assets/Start Line Layer.png');
    startLine = SpriteComponent()
      ..sprite = startSprite
      ..size = Vector2(440, 246)
      ..anchor = Anchor.bottomLeft
      ..priority = 0;
    add(startLine!);

    final finishSprite = await loadSprite('game_assets/Finish Line Layer.png');
    finishLine = SpriteComponent()
      ..sprite = finishSprite
      ..size = Vector2(440, 246)
      ..anchor = Anchor.bottomLeft
      ..priority = 0;
    add(finishLine!);

    // Decide your base Y for both lines; e.g., near the bottom of the screen
    startLineBaseY = size.y * 0.99;
    finishLineBaseY = size.y * 0.99;

    // The Start line is fully on screen at x=80.
    startLineBaseX = 80;
    // The Finish line is initially off-screen to the right.
    finishLineBaseX = size.x + 200;

    // 4) Ducks (priority=1) so they appear in front of lines
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

    duck1 = SpriteAnimationComponent()
      ..animation = duckAnimation
      ..size = Vector2(80, 80)
      ..position = Vector2(30, size.y * 0.70)
      ..priority = 1;
    add(duck1!);

    duck2 = SpriteAnimationComponent()
      ..animation = duckAnimation
      ..size = Vector2(80, 80)
      ..position = Vector2(30, size.y * 0.55)
      ..priority = 1;
    add(duck2!);

    duck3 = SpriteAnimationComponent()
      ..animation = duckAnimation
      ..size = Vector2(80, 80)
      ..position = Vector2(30, size.y * 0.40)
      ..priority = 1;
    add(duck3!);

    // 5) Duck labels (priority=2)
    final labelStyle1 = TextPaint(
      style: const TextStyle(
        fontSize: 11,
        fontFamily: 'Jaro',
        color: Color(0xFF90EE90),
        fontWeight: FontWeight.bold,
        shadows: [Shadow(blurRadius: 2, color: Colors.black, offset: Offset(1, 1))],
      ),
    );
    final labelStyle2 = TextPaint(
      style: const TextStyle(
        fontSize: 11,
        fontFamily: 'Jaro',
        color: Color(0xFFFF8C00),
        fontWeight: FontWeight.bold,
        shadows: [Shadow(blurRadius: 2, color: Colors.black, offset: Offset(1, 1))],
      ),
    );
    final labelStyle3 = TextPaint(
      style: const TextStyle(
        fontSize: 11,
        fontFamily: 'Jaro',
        color: Color(0xFF00BFFF),
        fontWeight: FontWeight.bold,
        shadows: [Shadow(blurRadius: 2, color: Colors.black, offset: Offset(1, 1))],
      ),
    );

    duck1Label = TextComponent(
      text: '',
      textRenderer: labelStyle1,
      anchor: Anchor.bottomCenter,
      priority: 2,
    );
    add(duck1Label!);

    duck2Label = TextComponent(
      text: '',
      textRenderer: labelStyle2,
      anchor: Anchor.bottomCenter,
      priority: 2,
    );
    add(duck2Label!);

    duck3Label = TextComponent(
      text: '',
      textRenderer: labelStyle3,
      anchor: Anchor.bottomCenter,
      priority: 2,
    );
    add(duck3Label!);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // 1) Track how far the water has scrolled
    waveScrollX += waterSpeedX * dt;

    // 2) Keep start line pinned to the wave movement
    if (startLine != null) {
      startLine!.position.x = startLineBaseX - waveScrollX;
      startLine!.position.y = startLineBaseY;
    }

    // 3) Move the finish line into the screen when scrolling is triggered.
    // Here, we want the finish line to move left until it stops at 30% of the screen width.
    if (finishLine != null) {
      if (startFinishLineScrolling) {
        finishLine!.position.x -= 80 * dt; // Move left at 80 pixels/sec.
        // Define a stop position (e.g., 30% of the screen width).
        double stopPosition = size.x * 0.01;
        if (finishLine!.position.x <= stopPosition) {
          finishLine!.position.x = stopPosition;
        }
        // Debug: Print the finish line X position.
        print('Finish line X position: ${finishLine!.position.x}');
      } else {
        // Keep the finish line off-screen.
        finishLine!.position.x = finishLineBaseX;
      }
      finishLine!.position.y = finishLineBaseY;
    }

    _updateLabelPositions();
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);

    // Recompute baseY for both lines on resize.
    startLineBaseY = canvasSize.y * 0.99;
    finishLineBaseY = canvasSize.y * 0.99;

    // Ducks
    if (duck1 != null) {
      final oldX = duck1!.position.x;
      duck1!.position = Vector2(oldX, canvasSize.y * 0.70);
    }
    if (duck2 != null) {
      final oldX = duck2!.position.x;
      duck2!.position = Vector2(oldX, canvasSize.y * 0.55);
    }
    if (duck3 != null) {
      final oldX = duck3!.position.x;
      duck3!.position = Vector2(oldX, canvasSize.y * 0.40);
    }

    _updateLabelPositions();
  }

  /// Reassign ducks based on top players.
  void updateDucks(List<Map<String, dynamic>> topPlayers) {
    if (topPlayers.isEmpty) {
      duck1PlayerId = duck2PlayerId = duck3PlayerId = null;
      duck1Label?.text = '';
      duck2Label?.text = '';
      duck3Label?.text = '';
      _updateLabelPositions();
      return;
    }

    if (topPlayers.isNotEmpty) {
      duck1PlayerId = topPlayers[0]['id'];
      duck1Label?.text = topPlayers[0]['name'] ?? '';
    } else {
      duck1PlayerId = null;
      duck1Label?.text = '';
    }

    if (topPlayers.length > 1) {
      duck2PlayerId = topPlayers[1]['id'];
      duck2Label?.text = topPlayers[1]['name'] ?? '';
    } else {
      duck2PlayerId = null;
      duck2Label?.text = '';
    }

    if (topPlayers.length > 2) {
      duck3PlayerId = topPlayers[2]['id'];
      duck3Label?.text = topPlayers[2]['name'] ?? '';
    } else {
      duck3PlayerId = null;
      duck3Label?.text = '';
    }

    _updateLabelPositions();
  }

  void _updateLabelPositions() {
    if (duck1 != null && duck1Label != null) {
      duck1Label!.position = duck1!.position + Vector2(duck1!.size.x / 2, -2);
    }
    if (duck2 != null && duck2Label != null) {
      duck2Label!.position = duck2!.position + Vector2(duck2!.size.x / 2, -2);
    }
    if (duck3 != null && duck3Label != null) {
      duck3Label!.position = duck3!.position + Vector2(duck3!.size.x / 2, -2);
    }
  }

  /// Move the duck assigned to that player's current rank.
  void moveDuckForPlayer(String playerId) {
    if (playerId == duck1PlayerId && duck1 != null) {
      duck1!.position.x += 25;
    } else if (playerId == duck2PlayerId && duck2 != null) {
      duck2!.position.x += 25;
    } else if (playerId == duck3PlayerId && duck3 != null) {
      duck3!.position.x += 25;
    }
    _updateLabelPositions();
  }
}

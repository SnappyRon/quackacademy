import 'dart:math' as math; // for math.pow
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Riverpod provider to expose the DuckRaceGame instance.
/// This allows external widgets to interact with the game if needed.
final duckRaceGameProvider = Provider<DuckRaceGame>((ref) => DuckRaceGame());

class DuckRaceGame extends FlameGame {
  static const int duckFrames = 15;

  // SpriteAnimationComponents for ducks.
  SpriteAnimationComponent? duck1;
  SpriteAnimationComponent? duck2;
  SpriteAnimationComponent? duck3;

  // Labels for each duck (e.g. player names).
  TextComponent? duck1Label;
  TextComponent? duck2Label;
  TextComponent? duck3Label;

  // Map from playerId to duck component and label for movement.
  final Map<String, SpriteAnimationComponent> playerDuckMap = {};
  final Map<String, TextComponent> playerLabelMap = {};

  // Persistent mapping: playerId => duck index (0,1,2).
  final Map<String, int> currentDuckAssignments = {};

  // Background and lines...
  ParallaxComponent? backgroundParallax;
  SpriteComponent? startLine;
  SpriteComponent? finishLine;
  double startLineBaseX = 60;
  double startLineBaseY = 0;
  double finishLineBaseX = 60;
  double finishLineBaseY = 0;
  double waveScrollX = 0;
  double waterSpeedX = 0;
  bool startFinishLineScrolling = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // 1) Parallax background.
    backgroundParallax = await loadParallaxComponent(
      [
        ParallaxImageData('game_assets/BG1(440x246).png'),
        ParallaxImageData('game_assets/BG2(440x246).png'),
        ParallaxImageData('game_assets/BG3(440x246).png'),
        ParallaxImageData('game_assets/BG4(440x246).png'),
        ParallaxImageData('game_assets/BG5(440x246).png'),
        ParallaxImageData('game_assets/BG6(440x246).png'),
      ],
      baseVelocity: Vector2(10, 0),
      velocityMultiplierDelta: Vector2(1.2, 0),
      repeat: ImageRepeat.repeatX,
    )..priority = -1;
    add(backgroundParallax!);

    // 2) Water layer speed calculation.
    waterSpeedX = 10 * math.pow(1.2, 4).toDouble();

    // 3) Create Start/Finish lines.
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

    startLineBaseY = size.y * 0.99;
    finishLineBaseY = size.y * 0.99;
    startLineBaseX = 80;
    finishLineBaseX = size.x + 200;

    // 4) Create Ducks.
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
      stepTime: 0.066,
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

    // 5) Create Duck labels.
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

    waveScrollX += waterSpeedX * dt;

    if (startLine != null) {
      startLine!.position.x = startLineBaseX - waveScrollX;
      startLine!.position.y = startLineBaseY;
    }

    if (finishLine != null) {
      if (startFinishLineScrolling) {
        finishLine!.position.x -= 80 * dt;
        double stopPosition = size.x * 0.0000009;
        if (finishLine!.position.x <= stopPosition) {
          finishLine!.position.x = stopPosition;
        }
      } else {
        finishLine!.position.x = finishLineBaseX;
      }
      finishLine!.position.y = finishLineBaseY;
    }

    _updateLabelPositions();
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);
    startLineBaseY = canvasSize.y * 0.99;
    finishLineBaseY = canvasSize.y * 0.99;

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

  /// Updates duck assignments for the current top 3.
  /// This method maintains persistent assignments:
  /// - If a player is already assigned, keep that assignment.
  /// - Assign a duck index (0,1,2) for any new top-3 player.
  /// - Remove assignments for players no longer in top-3.
  void updateDucks(List<Map<String, dynamic>> topPlayers) {
    // Create a set of the current top player IDs (max 3).
    Set<String> newTopIds = {};
    for (int i = 0; i < topPlayers.length && i < 3; i++) {
      newTopIds.add(topPlayers[i]['id'] as String);
    }

    // Remove assignments for players no longer in top-3.
    currentDuckAssignments.removeWhere((playerId, duckIndex) => !newTopIds.contains(playerId));

    // For each new top-3 player, assign a duck index if not already assigned.
    for (int i = 0; i < topPlayers.length && i < 3; i++) {
      final p = topPlayers[i];
      final playerId = p['id'] as String;
      final playerName = p['name'] ?? '';
      if (!currentDuckAssignments.containsKey(playerId)) {
        // Find the lowest available duck index.
        List<int> used = currentDuckAssignments.values.toList();
        int? freeIndex;
        for (int j = 0; j < 3; j++) {
          if (!used.contains(j)) {
            freeIndex = j;
            break;
          }
        }
        if (freeIndex != null) {
          currentDuckAssignments[playerId] = freeIndex;
        }
      }
      // Update the duck label and mapping based on the assigned duck index.
      switch (currentDuckAssignments[playerId]) {
        case 0:
          duck1Label?.text = playerName;
          playerDuckMap[playerId] = duck1!;
          playerLabelMap[playerId] = duck1Label!;
          break;
        case 1:
          duck2Label?.text = playerName;
          playerDuckMap[playerId] = duck2!;
          playerLabelMap[playerId] = duck2Label!;
          break;
        case 2:
          duck3Label?.text = playerName;
          playerDuckMap[playerId] = duck3!;
          playerLabelMap[playerId] = duck3Label!;
          break;
      }
    }
    _updateLabelPositions();
  }

  /// Moves the duck for a given player.
  void moveDuckForPlayer(String playerId) {
    print('moveDuckForPlayer($playerId)');
    print('playerDuckMap keys: ${playerDuckMap.keys.toList()}');

    final duck = playerDuckMap[playerId];
    if (duck != null) {
      // Calculate the target position: move 25 pixels to the right.
      final targetPosition = Vector2(duck.position.x + 25, duck.position.y);

      // Remove any existing MoveEffects to avoid stacking.
      duck.children.whereType<MoveEffect>().forEach((effect) {
        effect.removeFromParent();
      });

      // Add a smooth move effect with a half-second duration.
      duck.add(
        MoveEffect.to(
          targetPosition,
          EffectController(duration: 0.5, curve: Curves.easeInOut),
        ),
      );
      print('Moved duck for $playerId');
    } else {
      print('No duck found for $playerId');
    }
    _updateLabelPositions();
  }

  /// Updates label positions to remain above their ducks.
  void _updateLabelPositions() {
    playerDuckMap.forEach((playerId, duckComponent) {
      final label = playerLabelMap[playerId];
      if (label != null) {
        label.position = duckComponent.position + Vector2(duckComponent.size.x / 2, -2);
      }
    });
  }
}

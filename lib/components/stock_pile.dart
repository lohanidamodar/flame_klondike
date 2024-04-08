import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/painting.dart';
import 'package:mero_nepali/klondike_game.dart';

import 'card.dart';
import 'pile.dart';
import 'waste_pile.dart';

class StockPile extends PositionComponent with TapCallbacks, HasGameReference<KlondikeGame> implements Pile {
  StockPile({super.position}) : super(size: KlondikeGame.cardSize);
  final _borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10
    ..color = const Color(0xFF3F5B5D);
  final _circlePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 100
    ..color = const Color(0x883F5B5D);

  final List<Card> _cards = [];

  @override
  void acquireCard(Card card) {
    assert(!card.isFaceUp);
    card.position = position;
    card.priority = _cards.length;
    card.pile = this;
    _cards.add(card);
  }

  @override
  void onTapUp(TapUpEvent event) {
    final wastePile = parent!.firstChild<WastePile>()!;
    if (_cards.isEmpty) {
      wastePile.removeAllCards().reversed.forEach((card) {
        card.flip();
        acquireCard(card);
      });
    } else {
      for (var i = 0; i < game.klondikeDraw; i++) {
        if (_cards.isNotEmpty) {
          final card = _cards.removeLast();
          card.flip();
          wastePile.acquireCard(card);
        }
      }
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(KlondikeGame.cardRRect, _borderPaint);
    canvas.drawCircle(
      Offset(width / 2, height / 2),
      KlondikeGame.cardWidth * 0.3,
      _circlePaint,
    );
  }

  @override
  bool get debugMode => false;
  @override
  bool canAcceptCard(Card card) => false;
  @override
  bool canMoveCard(Card card) => false;

  @override
  void removeCard(Card card) =>
      throw StateError('cannot remove cards from here');
  @override
  void returnCard(Card card) =>
      throw StateError('cannot remove cards from here');
}

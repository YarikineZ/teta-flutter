import 'dart:io';

enum Suit { clubs, spades, diamonds, hearts }

final faces = [
  "2",
  "3",
  "4",
  "5",
  "6",
  "7",
  "8",
  "9",
  "10",
  "Jack",
  "Queen",
  "King",
  "Ace"
];

class Card {
  //TODO Может нужно было сделать через абстрактный класс?
  final Suit suit;
  final List suitLogo = ["♣︎", "♠︎", "♦︎", "♥︎"];
  final String face;

  Card(this.suit, this.face);

  String get info => "${suit.name} $face";
  int get value {
    if (["Jack", "Queen", "King"].contains(face)) {
      return 10;
    } else if (face == "Ace") {
      return 11;
    } else {
      return int.parse(face);
    }
  }

  @override
  String toString() => "$face${suitLogo[suit.index]}";
}

class CardDeck {
  List<Card> cards = [];

  CardDeck() {
    refill();
  }

  void _makeUniquePairs() {
    Card tmp;
    //TODO  есть более красивыый способоб генерации, хз как сделать по 2м листам
    for (var s in Suit.values) {
      for (var v in faces) {
        tmp = Card(s, v);
        cards.add(tmp);
      }
    }
  }

  Card pop() {
    if (cards.isNotEmpty) {
      var first = cards.first;
      cards.isNotEmpty ? cards.removeAt(0) : null;
      return (first);
    } else
      //TODO Требует написать else чтобы был NullSafety
      return Card(Suit.clubs, "ERR: DECK IS EMPTY");
  }

  void refill() {
    cards = [];
    _makeUniquePairs();
    cards.shuffle();
  }

  List<String> get info =>
      List.generate(cards.length, (index) => cards[index].info);
}

abstract class Player {
  List<Card> hand = [];
  int scoreSum = 0;

  void turn(CardDeck deck);

  void status(String prefix) {
    _calcSum();
    stdout.writeln("$prefix: $hand, $scoreSum");
  }

  int _calcSum() {
    scoreSum = 0;
    for (final card in hand) {
      scoreSum += card.value;
    }
    for (final card in hand) {
      if (card.face == "Ace" && scoreSum > 21) scoreSum -= 10;
    }
    return scoreSum;
  }

  void addCard(card) {
    hand.add(card);
  }
}

class User extends Player {
  bool looseFlag = false;

  void turn(CardDeck deck) {
    String? input = "";
    while (!looseFlag) {
      stdout.writeln("Ход Игрока (1 - Взять, 2 - Пас)");
      input = stdin.readLineSync();
      stdout.writeln();
      if (input == "1") {
        hand.add(deck.pop());
        _calcSum();
        status("И");
        scoreSum > 21 ? looseFlag = true : null;
      } else if (input == "2") {
        break;
      } else {
        stdout.writeln("Неверное значение");
      }
    }
  }
}

class Dealer extends Player {
  void turn(CardDeck deck) {
    status("Д");
    stdout.writeln("Ход Диллера");
    while (scoreSum < 18) {
      addCard(deck.pop());
      status("Д");
    }
  }
}

class BlackJack {
  CardDeck deck = CardDeck();
  User user = User();
  Dealer dealer = Dealer();

  BlackJack() {
    startDistribution();
    user.turn(deck);
    !user.looseFlag ? dealer.turn(deck) : null;
    fin();
  }

  void startDistribution() {
    stdout.writeln("\n\nРаздача");
    deck.refill();
    dealer.addCard(deck.pop());
    user.addCard(deck.pop());
    user.addCard(deck.pop());
    dealer.status("Д");
    user.status("И");
  }

  void fin() {
    stdout.writeln("======");
    dealer.status("Д");
    user.status("И");
    if (((21 - user.scoreSum) > (21 - dealer.scoreSum) || user.looseFlag) &&
        dealer.scoreSum <= 21) {
      stdout.writeln("Диллер победил");
    } else if (user.scoreSum == dealer.scoreSum) {
      stdout.writeln("Ничья");
    } else {
      stdout.writeln("Игрок победил");
    }
  }
}

void main(List<String> arguments) {
  String? input;
  BlackJack();
  while (true) {
    stdout.writeln("\nИграть еще? (y/n)");
    input = stdin.readLineSync();
    if (input == "y") {
      BlackJack();
    } else if (input == "n") {
      break;
    } else {
      stdout.writeln("\nНеверное значение!");
    }
  }
}

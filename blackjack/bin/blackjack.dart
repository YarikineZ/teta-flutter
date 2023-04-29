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
    var first = cards.first;
    cards.removeAt(0);
    return (first);
  }

  void refill() {
    cards = [];
    _makeUniquePairs();
    cards.shuffle();
  }

  List get info => List.generate(cards.length, (index) => cards[index].info);
}

class BlackJack {
  CardDeck deck = CardDeck();
  List<Card> deallersHand = [];
  List<Card> playersHand = [];
  //bool stopFlag = false;
  int playerSum = 0;
  int dealerSum = 0;
  bool winFlag = false;

  BlackJack() {
    newGame();
    _playersTurn();
    playerSum <= 21 ? _dealersTurn() : null;
    fin();
  }

  void newGame() {
    stdout.writeln("Раздача");
    deck.refill();
    deallersHand.add(deck.pop());
    playersHand.add(deck.pop());
    playersHand.add(deck.pop());
    status;
  }

  void _playersTurn() {
    String? input = "";
    while (!winFlag) {
      stdout.writeln("Ход Игрока (1 - Взять, 2 - Пас)");
      input = stdin.readLineSync();
      stdout.writeln();
      if (input == "1") {
        playersHand.add(deck.pop());
        _calcSums();
        status;
        playerSum > 21 ? winFlag = true : null;
      } else if (input == "2") {
        break;
      } else {
        stdout.writeln("Неверное значение (1 - Взять, 2 - Пас)");
      }
    }
  }

  void _dealersTurn() {
    stdout.writeln("Ход Диллера");
    while (dealerSum < 18) {
      deallersHand.add(deck.pop());
      status;
    }
  }

  void _calcSums() {
    playerSum = 0;
    dealerSum = 0;
    for (final el in playersHand) {
      playerSum += el.value;
    }

    for (final el in deallersHand) {
      dealerSum += el.value;
    }

    for (final card in playersHand) {
      if (card.face == "Ace" && playerSum > 21) playerSum -= 10;
    }

    for (final card in deallersHand) {
      if (card.face == "Ace" && dealerSum > 21) dealerSum -= 10;
    }
  }

  get status {
    _calcSums();
    stdout.writeln("Д: $deallersHand");
    stdout.writeln("И: $playersHand");
    stdout.writeln("DealerSum $dealerSum, PlayerSum $playerSum");
    stdout.writeln("—--------");
  }

  void fin() {
    if (((21 - playerSum) > (21 - dealerSum) || winFlag) && dealerSum <= 21) {
      stdout.writeln("Диллер победил");
    } else if (playerSum == dealerSum) {
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

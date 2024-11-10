
class MyCard {
  final String suit; // 花色
  final String rank; // 点数

  MyCard({required this.suit,  required this.rank});

  @override
  String toString() {
    return '$suit$rank';
  }
}
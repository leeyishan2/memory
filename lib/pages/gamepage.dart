// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api

import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:memory/components/card.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final List<String> suits = ['♠', '♥', '♣', '♦'];
  final List<String> ranks = ['A', 'J', 'Q', 'K'];

  Color? suitColor = Colors.purple[50];
  Color? rankColor = Colors.purple[50];
  
  
  List<MyCard> displayedCards = [];
  int currentCardIndex = 0;
  Timer? timer;
  
  int correctCount = 0;
  int wrongCount = 0;
  int missCount = 0;
  
  bool gameEnded = false;
  bool answered = false;

  final AudioPlayer cardFlipPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    initAudio();
    startGame();
  }

  void initAudio() async {
    await cardFlipPlayer.setPlayerMode(PlayerMode.lowLatency);
    await cardFlipPlayer.setVolume(0.5);
  }

  void playCardFlip() async {
    cardFlipPlayer.stop().then((_) {
      cardFlipPlayer.setSource(AssetSource('audio/cardflip.mp3')).then((_) {
        cardFlipPlayer.resume();
      });
    });
  }

  void startGame() {
    // 生成30张随机扑克牌
    List<MyCard> cards = [];
    for (int i = 0; i < 30; i++) {
      String suit = suits[Random().nextInt(suits.length)];
      String rank = ranks[Random().nextInt(ranks.length)];
      cards.add(MyCard(suit: suit, rank: rank));
    }
    
    displayedCards = cards;
    currentCardIndex = 0;
    startTimer();
  }

  void startTimer() {
    
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 3), (timer) async{
      // 先播放音效
      playCardFlip();
      
      // 添加小延迟让音效先播放
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        if (currentCardIndex >= 29) {
          timer.cancel();
          gameEnded = true;
          return;
        }
        
        if (currentCardIndex >= 2) {
          
          MyCard firstCard = displayedCards[currentCardIndex - 2];
          MyCard thirdCard = displayedCards[currentCardIndex];
          
          bool isSuitMatch = firstCard.suit == thirdCard.suit;
          bool isRankMatch = firstCard.rank == thirdCard.rank;

          if (!answered && (isSuitMatch || isRankMatch)) {
            missCount++;
          }
          answered = false;
          suitColor = Colors.purple[50];
          rankColor = Colors.purple[50];
        }
        
        currentCardIndex++;
        
      });
    });
  }

  void checkAnswer(String answerType) {
    if(currentCardIndex < 2) {
      return;
    }

    if(answered) {
      return;
    }

    MyCard firstCard = displayedCards[currentCardIndex - 2];
    MyCard thirdCard = displayedCards[currentCardIndex];
    
    bool isSuitMatch = firstCard.suit == thirdCard.suit;
    bool isRankMatch = firstCard.rank == thirdCard.rank;

    
    if ((answerType == 'suit' && isSuitMatch) || 
        (answerType == 'rank' && isRankMatch)) {
      setState(() {
        if (answerType == 'suit') {
          if(suitColor != Colors.green[50]){
            suitColor = Colors.green[50];
            correctCount++;
          }
        } else {
          if(rankColor != Colors.green[50]){
            rankColor = Colors.green[50];
            correctCount++;
          }
        }
      });
    } else {
      setState(() {
        if (answerType == 'suit') {
          if(suitColor != Colors.red[100]){
            suitColor = Colors.red[100];
            wrongCount++;
          }
        } else {
          if(rankColor != Colors.red[100]){
            rankColor = Colors.red[100];
            wrongCount++;
          }
        }
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            Padding(
              padding: const EdgeInsets.only(right: 20,),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '正确次数: $correctCount \n' 
                    '错误次数: $wrongCount \n' 
                    '错过次数: $missCount',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30,),

            Text(
              '${displayedCards[currentCardIndex].suit}${displayedCards[currentCardIndex].rank}',
              style: TextStyle(
                fontSize: 72,
                color: (displayedCards[currentCardIndex].suit == '♥' || displayedCards[currentCardIndex].suit == '♦')
                    ? Colors.red
                    : Colors.black,
              ),
            ),
            const SizedBox(height: 40),
            
            if (!gameEnded) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => checkAnswer('suit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: suitColor,
                    ),
                    child: const Text('花色相同'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () => checkAnswer('rank'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: rankColor,
                    ),
                    child: const Text('点数相同'),
                  ),
                ],
              ),
            ],
            
            
            if (gameEnded) ...[
              
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    gameEnded = false;
                    correctCount = 0;
                    wrongCount = 0;
                    missCount = 0;
                    startGame();
                  });
                },
                child: const Text('重新开始'),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
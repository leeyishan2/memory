

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:memory/pages/gamepage.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '记忆',
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5,),
            Text(
              '最美妙的事物',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 15,),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: const [BoxShadow(
                      color: Colors.grey,
                      spreadRadius: 1, 
                      blurRadius: 5,
                    )]
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  '游戏规则：\n'
                  '1. 每3秒出现一张新的扑克牌\n'
                  '2. 当出现第N张牌时，比较它与第N-2张牌\n'
                  '3. 如果花色相同点击"花色相同"\n'
                  '4. 如果点数相同点击"点数相同"\n'
                  '5. 总共有30张牌\n'
                  '准备好了吗？',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            
            SizedBox(height: 20,),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
              ),
              onPressed: () => Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => const GamePage(),
                )
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Icon(Icons.play_arrow_outlined, size: 30,),
              ),
            )
          ],
        ),
      ),
      
    );
  }
}
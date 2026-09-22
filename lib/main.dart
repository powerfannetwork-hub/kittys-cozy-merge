import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: KittysCozyMerge(),
  ));
}

class KittysCozyMerge extends StatefulWidget {
  @override
  _KittysCozyMergeState createState() => _KittysCozyMergeState();
}

class _KittysCozyMergeState extends State<KittysCozyMerge> {
  int energy = 5;
  int maxEnergy = 5;
  int coins = 500;
  int currentRoom = 1;
  Duration timeToNextEnergy = Duration(hours: 2);
  Timer? timer;

  // Board 4x4
  List<String> board = List.generate(16, (i) => i < 6? "yarn" : "empty");

  // Leaderboard Top 500 - misali
  List<Map<String, dynamic>> top500 = [
    {"name": "Emma", "coins": 5400, "room": 18},
    {"name": "Sophie", "coins": 4800, "room": 15},
    {"name": "YOU", "coins": 500, "room": 1},
  ];

  @override
  void initState() {
    super.initState();
    startEnergyTimer();
  }

  void startEnergyTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      if (timeToNextEnergy.inSeconds > 0) {
        setState(() => timeToNextEnergy -= Duration(seconds: 1));
      } else {
        if (energy < maxEnergy) {
          setState(() {
            energy++;
            timeToNextEnergy = Duration(hours: 2);
          });
        }
      }
    });
  }

  void doMerge(int index) {
    if (energy <= 0) {
      showSleepyPopup();
      return;
    }
    setState(() {
      energy--;
      coins += 10;
      // Yarn 2 = Scarf (simple logic)
      board[index] = board[index] == "yarn"? "scarf" : "blanket";
    });
  }

  void showSleepyPopup() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Color(0xFFFFF0F3),
        title: Text("Kitty is sleepy 😴", style: TextStyle(color: Colors.pink)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Energy ya kare!", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("⏳ Energy na gaba: ${timeToNextEnergy.inHours}h ${timeToNextEnergy.inMinutes % 60}m ${timeToNextEnergy.inSeconds % 60}s"),
            SizedBox(height: 10),
            Text("Jira awa 2 kyauta, ko tada Kitty yanzu da \$0.99"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Jira 2h"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
            onPressed: () {
              setState(() {
                energy = maxEnergy; // Biya $0.99 anan ne zaka saka In-App Purchase
                timeToNextEnergy = Duration(hours: 2);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Kitty ta farka! Meow 💖 - \$0.99")));
            },
            child: Text("Tada yanzu - \$0.99", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String timeStr = "${timeToNextEnergy.inHours}h ${timeToNextEnergy.inMinutes % 60}m ${timeToNextEnergy.inSeconds % 60}s";

    return Scaffold(
      backgroundColor: Color(0xFFFFF0F3),
      appBar: AppBar(
        backgroundColor: Colors.pink[100],
        title: Row(
          children: [
            Text("⚡ $energy/$maxEnergy", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(width: 10),
            Text("⏳ $timeStr", style: TextStyle(fontSize: 12)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.leaderboard, color: Colors.pink),
            onPressed: showLeaderboard,
          ),
        ],
      ),
      body: Column(
        children: [
          // Top bar Coins da Room
          Container(
            padding: EdgeInsets.all(12),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("💰 $coins Coins", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("🏠 Daki $currentRoom/20", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("🏆 Top 500", style: TextStyle(color: Colors.pink)),
              ],
            ),
          ),
          // Board
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 8, mainAxisSpacing: 8),
              itemCount: 16,
              itemBuilder: (_, i) {
                IconData icon = board[i] == "yarn"? Icons.circle : board[i] == "scarf"? Icons.checkroom : board[i] == "blanket"? Icons.bed : Icons.add;
                return GestureDetector(
                  onTap: () => doMerge(i),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.pink.shade100)),
                    child: Icon(icon, color: Colors.pink[300], size: 32),
                  ),
                );
              },
            ),
          ),
          // Daily Gift
          Container(
            margin: EdgeInsets.all(12),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.pink[50], borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Text("🎁 Kyautar Kullum: "),
                ElevatedButton(onPressed: (){ setState((){ coins+=50; }); }, child: Text("Karba 50 Coins")),
                Spacer(),
                Text("📦 Meow Box (6h)"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showLeaderboard() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("🏆 LEADERBOARD TOP 500", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.pink)),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: top500.length,
                itemBuilder: (_, i) => ListTile(
                  leading: Text("#${i+1}"),
                  title: Text(top500[i]['name']),
                  trailing: Text("💰 ${top500[i]['coins']} - Daki ${top500[i]['room']}"),
                  tileColor: top500[i]['name'] == "YOU"? Colors.pink[50] : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}

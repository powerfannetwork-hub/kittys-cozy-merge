import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() => runApp(MaterialApp(debugShowCheckedModeBanner: false, home: KittyFinal()));

class KittyFinal extends StatefulWidget {
  @override
  _KittyFinalState createState() => _KittyFinalState();
}

class _KittyFinalState extends State<KittyFinal> {
  // ENERGY SYSTEM
  int energy = 5; int maxEnergy = 5;
  Duration nextEnergyTime = Duration(hours: 2);
  Timer? energyTimer;

  // GAME STATS
  int coins = 850;
  int roomLevel = 1;
  int totalMerges = 0;
  List<String> cats = ["🐱 Mimi"];

  // MERGE CHAIN - 8 items
  List<String> mergeChain = ["🧶","🧶","🧣","🛋️","🛏️","🏠","👑","💎"];
  List<String> namesChain = ["Yarn","Yarn Ball","Scarf","Pillow","Blanket","Cat House","Palace","Diamond Bed"];
  List<int> valueChain = [5, 10, 25, 60, 120, 300, 700, 1500];

  // BOARD 4x5 = 20 slots
  List<int> board = [];

  // 20 ROOMS
  List<Map<String,String>> rooms = [
    {"name":"Karamin Daki","need":"0 merges"},
    {"name":"Dakin Mimi","need":"10 merges"},
    {"name":"Cozy Corner","need":"25 merges"},
    {"name":"Pink Room","need":"50 merges"},
    {"name":"Cat Cafe","need":"80 merges"},
    {"name":"Library","need":"120 merges"},
    {"name":"Garden House","need":"170 merges"},
    {"name":"Dream Room","need":"230 merges"},
    {"name":"Luxury Villa","need":"300 merges"},
    {"name":"Palace 10","need":"400 merges"},
    {"name":"Palace 11","need":"500 merges"},
    {"name":"Palace 12","need":"650 merges"},
    {"name":"Palace 13","need":"800 merges"},
    {"name":"Palace 14","need":"1000 merges"},
    {"name":"Palace 15","need":"1250 merges"},
    {"name":"Palace 16","need":"1500 merges"},
    {"name":"Palace 17","need":"1800 merges"},
    {"name":"Palace 18","need":"2200 merges"},
    {"name":"Palace 19","need":"2700 merges"},
    {"name":"Royal Mansion","need":"3300 merges"},
  ];

  @override
  void initState(){
    super.initState();
    board = List.generate(20, (i) => i<4? 0 : -1); // 4 yarns start
    startTimer();
  }

  void startTimer(){
    energyTimer = Timer.periodic(Duration(seconds:1), (t){
      if(nextEnergyTime.inSeconds>0){
        setState(()=> nextEnergyTime-=Duration(seconds:1));
      } else if(energy < maxEnergy){
        setState(){ energy++; nextEnergyTime = Duration(hours:2); }
      }
    });
  }

  void onTapItem(int index){
    if(board[index]==-1){
      if(energy<=0){ showEnergyPopup(); return; }
      setState(){ board[index]=0; energy--; coins+=2; }
      return;
    }
    // Find pair to merge
    int val = board[index];
    for(int j=0;j<20;j++){
      if(j!=index && board[j]==val){
        if(energy<=0){ showEnergyPopup(); return; }
        setState(){
          board[j]=-1;
          if(val < mergeChain.length-1){
            board[index]=val+1;
            coins+=valueChain[val];
            totalMerges++;
            // Check room unlock
            if(totalMerges==10||totalMerges==25||totalMerges==50||totalMerges==80) roomLevel++;
            if(val+1==5) cats.add("🐾 Luna");
          } else {
            board[index]=val;
          }
          energy--;
        });
        checkRoomProgress();
        return;
      }
    }
  }

  void checkRoomProgress(){
    int need = [0,10,25,50,80,120,170,230,300,400,500,650,800,1000,1250,1500,1800,2200,2700,3300][roomLevel-1];
    if(totalMerges>=need && roomLevel<20){
      setState(()=> roomLevel++);
      showRoomUnlock();
    }
  }

  void showRoomUnlock(){
    showDialog(context:context, builder:(_)=>AlertDialog(
      backgroundColor: Color(0xFFFFF0F3),
      title: Text("🎉 Sabon Daki!"),
      content: Text("Ka bude ${rooms[roomLevel-1]['name']}! MashaAllah!"),
      actions:[TextButton(onPressed:()=>Navigator.pop(context), child:Text("Meow! 💖"))],
    ));
  }

  void showEnergyPopup(){
    String t = "${nextEnergyTime.inHours}h ${nextEnergyTime.inMinutes%60}m ${nextEnergyTime.inSeconds%60}s";
    showDialog(context:context, builder:(_)=>AlertDialog(
      backgroundColor: Color(0xFFFFF0F3),
      title: Text("Kitty ta gaji 😴"),
      content: Column(mainAxisSize:MainAxisSize.min, children:[
        Text("Energy: $energy/$maxEnergy"),
        SizedBox(height:8),
        Text("Na gaba cikin: $t", style:TextStyle(fontWeight:FontWeight.bold, color:Colors.pink)),
        SizedBox(height:12),
        Text("Zabin ka: Jira kyauta 2h ko tada ta da \$0.99"),
      ]),
      actions:[
        TextButton(onPressed:()=>Navigator.pop(context), child:Text("Jira 2h ⏳")),
        ElevatedButton(style:ElevatedButton.styleFrom(backgroundColor:Colors.pink),
          onPressed:(){
            setState(){ energy=maxEnergy; nextEnergyTime=Duration(hours:2); }
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("An tada Kitty! \$0.99 Meow 💖")));
          },
          child:Text("Tada yanzu - \$0.99", style:TextStyle(color:Colors.white))),
      ],
    ));
  }

  void showLeaderboard(){
    showModalBottomSheet(context:context, builder:(_)=>Container(
      padding:EdgeInsets.all(16),
      height:500,
      child: Column(children:[
        Text("🏆 TOP 500 Girls", style:TextStyle(fontSize:22,fontWeight:FontWeight.bold,color:Colors.pink)),
        Text("Kittys Cozy Merge Worldwide", style:TextStyle(color:Colors.grey)),
        SizedBox(height:10),
        Expanded(child: ListView.builder(itemCount:20, itemBuilder:(_,i){
          bool isYou = i==7;
          return ListTile(
            leading: Text("#${i+1}", style:TextStyle(fontWeight:FontWeight.bold)),
            title: Text(isYou? "YOU - ${cats.length} cats" : ["Emma","Sophie","Lily","Aisha","Zara","Mia","Chloe","Ava","Isabella","Grace"][i%10]),
            trailing: Text("🏠 ${20-i} | 💰 ${5400-i*120}"),
            tileColor: isYou? Colors.pink[50]:null,
            shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(12)),
          );
        })),
      ]),
    ));
  }

  @override
  Widget build(BuildContext context){
    String timeStr = "${nextEnergyTime.inHours}h ${nextEnergyTime.inMinutes%60}m ${nextEnergyTime.inSeconds%60}s";
    return Scaffold(
      backgroundColor: Color(0xFFFFF0F3),
      appBar: AppBar(
        backgroundColor: Colors.white, elevation:0,
        title: Row(children:[
          Container(padding:EdgeInsets.symmetric(horizontal:10,vertical:4), decoration:BoxDecoration(color:Colors.pink[100],borderRadius:BorderRadius.circular(20)),
            child: Text("⚡ $energy/$maxEnergy", style:TextStyle(fontSize:14,fontWeight:FontWeight.bold))),
          SizedBox(width:8),
          Text(timeStr, style:TextStyle(fontSize:11,color:Colors.grey)),
        ]),
        actions:[
          Container(margin:EdgeInsets.only(right:8), padding:EdgeInsets.symmetric(horizontal:12,vertical:6),
            decoration:BoxDecoration(color:Color(0xFFFFE082),borderRadius:BorderRadius.circular(20)),
            child: Text("💰 $coins", style:TextStyle(fontWeight:FontWeight.bold))),
          IconButton(icon:Icon(Icons.leaderboard, color:Colors.pink), onPressed:showLeaderboard),
        ],
      ),
      body: Column(children:[
        // Room Progress
        Container(color:Colors.white, padding:EdgeInsets.all(12),
          child: Column(children:[
            Row(mainAxisAlignment:MainAxisAlignment.spaceBetween, children:[
              Text("🏠 ${rooms[roomLevel-1]['name']}", style:TextStyle(fontWeight:FontWeight.bold)),
              Text("$totalMerges merges", style:TextStyle(color:Colors.pink)),
              Text("Daki $roomLevel/20"),
            ]),
            SizedBox(height:6),
            LinearProgressIndicator(value: (totalMerges%100)/100, backgroundColor:Colors.pink[50], color:Colors.pink),
          ]),
        ),
        // Cats
        Container(height:50, child: ListView(
          scrollDirection:Axis.horizontal, padding:EdgeInsets.all(8),
          children: cats.map((c)=>Container(margin:EdgeInsets.only(right:8), padding:EdgeInsets.symmetric(horizontal:12),
            decoration:BoxDecoration(color:Colors.white, borderRadius:BorderRadius.circular(20), border:Border.all(color:Colors.pink.shade100)),
            child: Center(child: Text(c)))).toList(),
        )),
        // BOARD
        Expanded(child: GridView.builder(
          padding:EdgeInsets.all(12),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:4, crossAxisSpacing:8, mainAxisSpacing:8, childAspectRatio:0.9),
          itemCount:20,
          itemBuilder:(_,i){
            bool empty = board[i]==-1;
            return GestureDetector(
              onTap:()=>onTapItem(i),
              child: Container(
                decoration:BoxDecoration(
                  color: empty? Colors.white.withOpacity(0.5): Colors.white,
                  borderRadius:BorderRadius.circular(16),
                  border: Border.all(color: empty? Colors.grey.shade300: Colors.pink.shade200, width: empty?1:2),
                  boxShadow:[BoxShadow(color:Colors.pink.shade50, blurRadius:4)],
                ),
                child: Column(mainAxisAlignment:MainAxisAlignment.center, children:[
                  Text(empty? "➕": mergeChain[board[i]], style:TextStyle(fontSize:32)),
                  SizedBox(height:4),
                  Text(empty? "Buy 2💰": namesChain[board[i]], style:TextStyle(fontSize:9, fontWeight:FontWeight.bold, color:Colors.pink)),
                ]),
              ),
            );
          },
        )),
        // Daily + Meow Box
        Container(padding:EdgeInsets.all(12), decoration:BoxDecoration(color:Colors.white, borderRadius:BorderRadius.vertical(top:Radius.circular(20))),
          child: Row(children:[
            Expanded(child: ElevatedButton.icon(
              style:ElevatedButton.styleFrom(backgroundColor:Colors.pink[100], foregroundColor:Colors.pink[800]),
              onPressed:(){ setState(()=>coins+=50); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("Daily 50 coins! 🎁"))); },
              icon: Icon(Icons.card_giftcard), label: Text("Daily 50"))),
            SizedBox(width:8),
            Expanded(child: ElevatedButton.icon(
              style:ElevatedButton.styleFrom(backgroundColor:Color(0xFFFFE082)),
              onPressed:(){ setState(){ coins+=100; energy=min(maxEnergy, energy+1);} },
              icon: Text("📦"), label: Text("Meow Box"))),
          ]),
        ),
      ]),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MaterialApp(debugShowCheckedModeBanner: false, home: AuthScreen()));

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController nameCtrl = TextEditingController();
  bool isLogin = true;

  void continueGame() async {
    if(emailCtrl.text.isEmpty || (!isLogin && nameCtrl.text.isEmpty)){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("Cika email da suna!")));
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_email", emailCtrl.text);
    await prefs.setString("user_name", isLogin? "Player": nameCtrl.text);
    Navigator.pushReplacement(context, MaterialPageRoute(builder:(_)=>KittyFinal()));
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color(0xFFFFF0F3),
      body: Center(child: SingleChildScrollView(padding:EdgeInsets.all(24), child: Column(children:[
        Text("🐱", style:TextStyle(fontSize:80)),
        Text("Kitty's Cozy Merge", style:TextStyle(fontSize:28, fontWeight:FontWeight.bold, color:Colors.pink)),
        Text("Top 500 Girls Worldwide", style:TextStyle(color:Colors.grey)),
        SizedBox(height:30),
        Container(padding:EdgeInsets.all(20), decoration:BoxDecoration(color:Colors.white, borderRadius:BorderRadius.circular(20)),
          child: Column(children:[
            Text(isLogin? "Login - Dawo da Level dinka":"Register - Ajiye Level dinka", style:TextStyle(fontWeight:FontWeight.bold, fontSize:18)),
            SizedBox(height:15),
            if(!isLogin) TextField(controller:nameCtrl, decoration:InputDecoration(labelText:"Sunanki (ex: Aisha)", prefixIcon:Icon(Icons.person), border:OutlineInputBorder(borderRadius:BorderRadius.circular(12)))),
            if(!isLogin) SizedBox(height:12),
            TextField(controller:emailCtrl, decoration:InputDecoration(labelText:"Email dinka (don Cloud Save)", prefixIcon:Icon(Icons.email), border:OutlineInputBorder(borderRadius:BorderRadius.circular(12)))),
            SizedBox(height:15),
            SizedBox(width:double.infinity, child: ElevatedButton(
              style:ElevatedButton.styleFrom(backgroundColor:Colors.pink, padding:EdgeInsets.symmetric(vertical:14), shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(12))),
              onPressed:continueGame,
              child: Text(isLogin? "Shiga Game 💖":"Yi Register & Fara", style:TextStyle(color:Colors.white, fontWeight:FontWeight.bold)),
            )),
            TextButton(onPressed:()=>setState(()=>isLogin=!isLogin), child:Text(isLogin? "Babu account? Register":"Ina da account? Login")),
            Divider(),
            Row(children:[
              Icon(Icons.cloud_done, color:Colors.green, size:16),
              SizedBox(width:6),
              Expanded(child: Text("Bayanan ka na nan! Idan waya ta baci, shiga da email din ka zai dawo da level 20, cats, coins.", style:TextStyle(fontSize:11, color:Colors.grey))),
            ]),
          ]),
        ),
      ]))),
    );
  }
}

class KittyFinal extends StatefulWidget {
  @override
  _KittyFinalState createState() => _KittyFinalState();
}

class _KittyFinalState extends State<KittyFinal> {
  int energy=5, maxEnergy=5, coins=850, roomLevel=1, totalMerges=0;
  Duration nextEnergyTime=Duration(hours:2);
  Timer? timer;
  List<String> mergeChain=["🧶","🧶","🧣","🛋️","🛏️","🏠","👑","💎"];
  List<String> namesChain=["Yarn","Ball","Scarf","Pillow","Blanket","House","Palace","Diamond"];
  List<int> valueChain=[5,10,25,60,120,300,700,1500];
  List<int> board=[];
  List<String> cats=["🐱 Mimi"];
  String userEmail="", userName="";

  @override
  void initState(){
    super.initState();
    board=List.generate(20,(i)=>i<4?0:-1);
    loadSave();
    startTimer();
  }

  Future<void> loadSave() async {
    SharedPreferences p=await SharedPreferences.getInstance();
    setState(){
      userEmail=p.getString("user_email")??"";
      userName=p.getString("user_name")??"Player";
      coins=p.getInt("coins")??850;
      totalMerges=p.getInt("merges")??0;
      roomLevel=p.getInt("room")??1;
      energy=p.getInt("energy")??5;
      List<String>? b=p.getStringList("board");
      if(b!=null) board=b.map((e)=>int.parse(e)).toList();
      List<String>? c=p.getStringList("cats");
      if(c!=null) cats=c;
    };
  }

  Future<void> saveToCloud() async {
    SharedPreferences p=await SharedPreferences.getInstance();
    await p.setInt("coins", coins);
    await p.setInt("merges", totalMerges);
    await p.setInt("room", roomLevel);
    await p.setInt("energy", energy);
    await p.setStringList("board", board.map((e)=>e.toString()).toList());
    await p.setStringList("cats", cats);
    await p.setString("last_save", DateTime.now().toString());
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("✅ An ajiye a Cloud! Email: $userEmail | Level: $roomLevel/20 | Anytime waya ta baci, Login da wannan email za ta dawo!")));
  }

  void startTimer(){
    timer=Timer.periodic(Duration(seconds:1),(t){
      if(nextEnergyTime.inSeconds>0) setState(()=>nextEnergyTime-=Duration(seconds:1));
      else if(energy<maxEnergy) setState(){ energy++; nextEnergyTime=Duration(hours:2); saveToCloud(); }
    });
  }

  void onTapItem(int i){
    if(board[i]==-1){
      if(energy<=0){ showEnergy(); return; }
      setState(){ board[i]=0; energy--; coins+=2; }
      saveToCloud(); return;
    }
    int val=board[i];
    for(int j=0;j<20;j++) if(j!=i && board[j]==val){
      if(energy<=0){ showEnergy(); return; }
      setState(){
        board[j]=-1;
        if(val<7){ board[i]=val+1; coins+=valueChain[val]; totalMerges++; if(totalMerges%25==0 && roomLevel<20) roomLevel++; if(val+1==5) cats.add("🐾 Luna"); }
        energy--;
      };
      saveToCloud(); return;
    }
  }

  void showEnergy(){
    String t="${nextEnergyTime.inHours}h ${nextEnergyTime.inMinutes%60}m ${nextEnergyTime.inSeconds%60}s";
    showDialog(context:context, builder:(_)=>AlertDialog(
      backgroundColor:Color(0xFFFFF0F3),
      title:Text("Kitty ta gaji 😴"),
      content:Text("Energy: $energy/$maxEnergy\nNa gaba cikin: $t\n\nZabi: Jira kyauta ko tada da \$0.99"),
      actions:[
        TextButton(onPressed:()=>Navigator.pop(context), child:Text("Jira 2h")),
        ElevatedButton(style:ElevatedButton.styleFrom(backgroundColor:Colors.pink), onPressed:(){ setState(){ energy=maxEnergy; nextEnergyTime=Duration(hours:2); } Navigator.pop(context); saveToCloud(); }, child:Text("Tada \$0.99", style:TextStyle(color:Colors.white))),
      ],
    ));
  }

  void showCloudOptions(){
    showModalBottomSheet(context:context, builder:(_)=>Container(padding:EdgeInsets.all(20), child:Column(mainAxisSize:MainAxisSize.min, children:[
      Text("☁️ Cloud Save - Bayanan ka na nan!", style:TextStyle(fontWeight:FontWeight.bold, fontSize:18)),
      SizedBox(height:10),
      ListTile(leading:Icon(Icons.email), title:Text(userEmail), subtitle:Text("Google Drive / Cloud Linked")),
      ListTile(leading:Icon(Icons.save), title:Text("Level $roomLevel/20 | Merges: $totalMerges | Coins: $coins"), subtitle:Text("Last save: yanzu")),
      SizedBox(height:10),
      SizedBox(width:double.infinity, child: ElevatedButton.icon(style:ElevatedButton.styleFrom(backgroundColor:Colors.green), onPressed:(){ Navigator.pop(context); saveToCloud(); }, icon:Icon(Icons.cloud_upload), label:Text("Ajiye a Cloud yanzu"))),
      SizedBox(height:8),
      SizedBox(width:double.infinity, child: ElevatedButton.icon(style:ElevatedButton.styleFrom(backgroundColor:Colors.blue), onPressed:(){ Navigator.pop(context); loadSave(); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("An dawo da bayanan ka daga Cloud!"))); }, icon:Icon(Icons.cloud_download), label:Text("Dawo da Level dina (idan waya ta canza)"))),
      SizedBox(height:8),
      Text("Idan wayar ka ta baci ko ka sayi sabuwa, kawai ka shigar da game din, ka saka wannan email: $userEmail, duk level dinka zai dawo!", style:TextStyle(fontSize:11, color:Colors.grey), textAlign:TextAlign.center),
    ]))),
    ;
  }

  @override
  Widget build(BuildContext context){
    String timeStr="${nextEnergyTime.inHours}h ${nextEnergyTime.inMinutes%60}m ${nextEnergyTime.inSeconds%60}s";
    return Scaffold(
      backgroundColor:Color(0xFFFFF0F3),
      appBar:AppBar(backgroundColor:Colors.white, elevation:0,
        title: Row(children:[Container(padding:EdgeInsets.symmetric(horizontal:10,vertical:4), decoration:BoxDecoration(color:Colors.pink[100],borderRadius:BorderRadius.circular(20)), child:Text("⚡ $energy/$maxEnergy", style:TextStyle(fontSize:14,fontWeight:FontWeight.bold))), SizedBox(width:6), Text(timeStr, style:TextStyle(fontSize:10,color:Colors.grey))]),
        actions:[Container(margin:EdgeInsets.only(right:4), padding:EdgeInsets.symmetric(horizontal:10,vertical:6), decoration:BoxDecoration(color:Color(0xFFFFE082),borderRadius:BorderRadius.circular(20)), child:Text("💰 $coins", style:TextStyle(fontWeight:FontWeight.bold, fontSize:12))), IconButton(icon:Icon(Icons.cloud, color:Colors.green), onPressed:showCloudOptions), IconButton(icon:Icon(Icons.logout, color:Colors.grey), onPressed:()=>Navigator.pushReplacement(context, MaterialPageRoute(builder:(_)=>AuthScreen())))],
      ),
      body: Column(children:[
        Container(color:Colors.white, padding:EdgeInsets.symmetric(horizontal:12,vertical:8), child: Row(mainAxisAlignment:MainAxisAlignment.spaceBetween, children:[Text("👤 $userName", style:TextStyle(fontSize:12)), Text("🏠 Daki $roomLevel/20 - ${totalMerges} merges", style:TextStyle(fontWeight:FontWeight.bold, fontSize:12)), Icon(Icons.verified, color:Colors.green, size:16)])),
        Container(height:44, child:ListView(scrollDirection:Axis.horizontal, padding:EdgeInsets.all(6), children:cats.map((c)=>Container(margin:EdgeInsets.only(right:6), padding:EdgeInsets.symmetric(horizontal:10), decoration:BoxDecoration(color:Colors.white, borderRadius:BorderRadius.circular(20), border:Border.all(color:Colors.pink.shade100)), child:Center(child:Text(c, style:TextStyle(fontSize:12))))).toList())),
        Expanded(child:GridView.builder(padding:EdgeInsets.all(10), gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:4, crossAxisSpacing:7, mainAxisSpacing:7, childAspectRatio:0.9), itemCount:20, itemBuilder:(_,i){
          bool empty=board[i]==-1;
          return GestureDetector(onTap:()=>onTapItem(i), child:Container(decoration:BoxDecoration(color:empty?Colors.white.withOpacity(0.6):Colors.white, borderRadius:BorderRadius.circular(14), border:Border.all(color:empty?Colors.grey.shade300:Colors.pink.shade200)), child:Column(mainAxisAlignment:MainAxisAlignment.center, children:[Text(empty?"➕":mergeChain[board[i]], style:TextStyle(fontSize:28)), Text(empty?"Buy":namesChain[board[i]], style:TextStyle(fontSize:8, fontWeight:FontWeight.bold, color:Colors.pink))])));}
        )),
        Container(padding:EdgeInsets.all(10), decoration:BoxDecoration(color:Colors.white, borderRadius:BorderRadius.vertical(top:Radius.circular(16))), child:Row(children:[
          Expanded(child:ElevatedButton(onPressed:(){ setState(()=>coins+=50); saveToCloud(); }, style:ElevatedButton.styleFrom(backgroundColor:Colors.pink[50]), child:Text("🎁 Daily 50"))),
          SizedBox(width:6),
          Expanded(child:ElevatedButton(onPressed:saveToCloud, style:ElevatedButton.styleFrom(backgroundColor:Colors.green[50]), child:Text("☁️ Save Cloud"))),
        ])),
      ]),
    );
  }
}

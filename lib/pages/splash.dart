import 'dart:async';
import 'package:flutter/material.dart';
import 'package:Wallet/controllers/db_helper.dart';
import 'package:Wallet/pages/homepage.dart';
import 'package:Wallet/pages/main_name.dart';
import 'package:Wallet/static.dart' as Static;


class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  dbHelper DbHelper=dbHelper();

  Future getSettings()async {
    
    String? name= await DbHelper.getName();
    if(name!=null){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomePage()));
    }else{
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>MainName()));
      
    }

  }
@override
void initState(){
  super.initState();
  getSettings();
  Timer(Duration(seconds: 10), () { });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
    backgroundColor: Static.PrimaryMaterialColor,
    body: Center(
      child: Container(
         padding:EdgeInsets.all(16.0),
         child:Image.asset("assets/mymoney.png",
         width: 100.0,
         height: 100.0,
         ),
     
      ),
      
    ),
    );
  }
}
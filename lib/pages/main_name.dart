import 'package:flutter/material.dart';
import 'package:Wallet/controllers/db_helper.dart';
import 'package:Wallet/pages/homepage.dart';
import 'package:Wallet/static.dart' as Static;

class MainName extends StatefulWidget {
  const MainName({super.key});

  @override
  State<MainName> createState() => _MainNameState();
}

class _MainNameState extends State<MainName> {

  dbHelper DbHelper=dbHelper();
  String name="";




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
    backgroundColor:// Colors.blue[900], 
    Color(0xffe2e7ef),
    body: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
           // alignment: Alignment.center,
            // decoration: BoxDecoration(
            //   color: Colors.white,
            //   borderRadius: BorderRadius.circular(12.0
            //   ,)
            // ),
             padding:EdgeInsets.all(16.0),
             child:Image.asset("assets/mymoney.png",
             width: 80.0,
             height: 80.0,
             ),
           
          ),
          SizedBox(
            height: 12.0,
          ),
          Text("THE WALLET",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.w900,
             color: Static.PrimaryMaterialColor[600]
          ),
          ),
          SizedBox(
            height: 12.0,
          ),
          Text("Let's get started",style: TextStyle(fontSize: 20.0,color: Static.PrimaryMaterialColor,fontWeight: FontWeight.w500),),
          SizedBox(
            height: 12.0,
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0
                ,)
              ),
              padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(hintText: "Enter your Name",
              border: InputBorder.none,
              ),
              style: TextStyle(
                fontSize: 20.0,
              ),
              maxLength: 12,
              onChanged: (val){
                name=val;
              },
            )
            ),
             SizedBox(
            height: 12.0,
          ),
          SizedBox(
            height: 50.0,
            width: double.maxFinite,
            child: ElevatedButton(onPressed:() async{
              if (name.isNotEmpty) {
                 dbHelper DbHelper=dbHelper();
                    await DbHelper.MainName(name);
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ));
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(
                    //     action: SnackBarAction(
                    //       label: "OK",
                    //       onPressed: () {
                    //         ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    //       },
                    //     ),
                    //     backgroundColor: Colors.white,
                    //     content: Text(
                    //       "Please Enter a name",
                    //       style: TextStyle(
                    //         color: Colors.black,
                    //         fontSize: 18.0,
                    //       ),
                    //     ),
                    //   ),
                    // );
                  } else {
                    //  ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(
                    //     action: SnackBarAction(
                    //       label: "OK",
                    //       onPressed: () {
                    //         ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    //       },
                    //     ),
                    //     backgroundColor: Colors.white,
                    //     content: Text(
                    //       "Please Enter a name",
                    //       style: TextStyle(
                    //         color: Colors.black,
                    //         fontSize: 18.0,
                    //       ),
                    //     ),
                    //   ),
                    // );
                    print("hi");
                  }
                },
             child: 
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
            children:[
            Text("Continue",
            style: TextStyle(
                fontSize: 20.0,
              ),
              ),
              SizedBox(
                width: 6.0,

              ),
              Icon(Icons.navigate_next_outlined)

            ]
            ),
            ),
          ),
        ],
      ),
    ),
    );
  }
}
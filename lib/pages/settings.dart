import 'package:Wallet/controllers/db_helper.dart';
import 'package:Wallet/pages/widgets/dialog_input.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  dbHelper DbHelper=dbHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[700],
      appBar: AppBar(
        title:Text("Settings"),
      ),
      body: ListView(
        padding: EdgeInsets.all(12.0
        ),
        children: [
          ListTile(
            onTap: () async{
              String EditedName="";
              String? name=await showDialog(context: context, builder: (context)=>AlertDialog(
                backgroundColor: Colors.grey[300],
                  title: Text(
                    "Enter new name",
                  ),
                  content: Container(
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                     child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Your Name",
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                      maxLength: 12,
                      onChanged: (val) {
                        EditedName = val;
                      },
                    ),
                  ),
                  actions: [
                    ElevatedButton(onPressed: 
                    (){
                      Navigator.of(context).pop(EditedName);
                    }, child: Text("OK")
                    ),
                  ],
              )
              );
              if(name!=null && name.isNotEmpty){
                dbHelper DbHelper=dbHelper();
                await DbHelper.MainName(name);
              }
            },
            tileColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 20.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                8.0,
              ),
            ),
            title: Text(
              "Change Name",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w800,
              ),
            ),
            // subtitle: Text(
            //   "Welcome {newname}",
            // ),
            trailing: Icon(
              Icons.change_circle,
              size: 32.0,
              color: Colors.black87,
            ),


          ),
          SizedBox(
            height: 20.0,
          ),
          ListTile(
            onTap: () async{
              bool reply=await showConfirmDialog(context,"Warning", "Confirm to delete the details" );
              if(reply){
                 await DbHelper.cleanData();
                 Navigator.of(context).pop();
              }
            },
            tileColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 20.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                8.0
              ),
            ),
            title: Text("Clear Data",
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w800,
            ),
            ),
             trailing: Icon(
              Icons.delete_forever,
              size: 32.0,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
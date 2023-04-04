import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Wallet/pages/main_name.dart';

class dbHelper{

  late Box box;
  late SharedPreferences preferences;

  dbHelper(){
    openBox();
    
  }
  openBox(){
    box=Hive.box('money');
  }

  Future deleteData(
    int index,
  ) async {
    await box.deleteAt(index);
  }

  Future cleanData() async {
    await box.clear();
  }

  Future addData(int amount,DateTime optdate, String note, String type) async{
    var value={'amount':amount, 'date':optdate, 'type':type, 'note':note};
    box.add(value);
  }

  // Future<Map> fetch(){
  //   if(box.values.isEmpty){
  //     return Future.value({});
  //   }else{
  //     return Future.value(box.toMap());
  //   }
  // }
  MainName(String name)async{
    preferences=await SharedPreferences.getInstance();
    preferences.setString('name', name);
  }

  getName()async{
    preferences=await SharedPreferences.getInstance();
    return preferences.getString('name');
  }
}
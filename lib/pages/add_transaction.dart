import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Wallet/controllers/db_helper.dart';
import 'package:Wallet/static.dart' as Static;

class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {

  late int amount;
  String note="Some Expense";
  String type="Income";
  DateTime optdate=DateTime.now();


  List <String> months=[
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  Future <void>_optdate(BuildContext context) async{
    final DateTime? picked=await showDatePicker(context: context, 
    initialDate: optdate, 
    firstDate: DateTime(2020,12),
     lastDate:DateTime(2023,4));
  if(picked!=null && picked!=optdate){
    setState(() {
      optdate=picked;
    });
  }
  }
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
        ),
        backgroundColor: Color(0xffe2e7ef),
        body: ListView(
          padding: EdgeInsets.all(12.0),
          children: [
            SizedBox(
              height: 20.0,
            ),
            Text(
              "Add Transaction",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                Container(
                    decoration: BoxDecoration(
                        color: Static.PrimaryMaterialColor,
                        borderRadius: BorderRadius.circular(16.0)),
                    padding: EdgeInsets.all(12.0),
                    child: Icon(
                      Icons.attach_money,
                      size: 24.0,
                      color: Colors.white,
                    )
                    ),
                SizedBox(
                  width: 12.0,
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "0",
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      fontSize: 24.0,
                    ),
                    onChanged: (val){
                      try{
                        amount=int.parse(val);
                      }
                      catch (e) {}
                    },
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                Container(
                    decoration: BoxDecoration(
                        color: Static.PrimaryMaterialColor,
                        borderRadius: BorderRadius.circular(16.0)),
                    padding: EdgeInsets.all(12.0),
                    child: Icon(
                      Icons.description,
                      size: 24.0,
                      color: Colors.white,
                    )),
                SizedBox(
                  width: 12.0,
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Category",
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                    onChanged: (val){note=val;
                    },
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Static.PrimaryMaterialColor,
                      borderRadius: BorderRadius.circular(16.0)),
                  padding: EdgeInsets.all(12.0),
                  child: Icon(
                    Icons.moving_sharp,
                    size: 24.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 12.0,
                ),
                ChoiceChip(
                    label: Text("Income",
                    style: TextStyle(fontSize: 16.0,color:type== "Income" ? Colors.white: Colors.black),
                    ),
                    selectedColor: Static.PrimaryMaterialColor,
                    selected: type== "Income" ? true:false,
                    onSelected: (val){
                      if(val){
                        setState(() {
                          type= "Income";
                        });
                      }
                    },
                    ),
                SizedBox(
                  width: 12.0,
                ),
                   ChoiceChip(
                    label: Text("Expense",
                    style: TextStyle(fontSize: 16.0,color:type== "Expense" ? Colors.white: Colors.black),
                    ),
                    selectedColor: Static.PrimaryMaterialColor,
                    selected: type== "Expense" ? true:false,
                    onSelected: (val){
                      if(val){
                        setState(() {
                          type= "Expense";
                        });
                      }
                    },
                    ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            SizedBox(
              height: 50.0,
              child: TextButton(onPressed: () {
                _optdate(context);
              }, 
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero)
              ),
              child: 
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Static.PrimaryMaterialColor,
                      borderRadius: BorderRadius.circular(16.0
                      )
                    ),
                    padding: EdgeInsets.all(12.0
                    ),
                    child: Icon(
                      Icons.date_range,
                      size: 24.0,
                      color:Colors.white
                    ),
                  ),
                  SizedBox(
                    width: 12.0,
                  ),
                  Text(
                "${optdate.day} ${months[optdate.month-1]}"
                ,style: TextStyle(
                  fontSize: 20,
                ),)
                ],
              )
                )
                ),
            SizedBox(
              height: 20.0,
            ),
            SizedBox(
              height:50.0,
                child: ElevatedButton(
                    onPressed: (){
                      if(amount!=null){
                        dbHelper DbHelper=dbHelper();
                       DbHelper.addData(amount, optdate, note, type);
                       Navigator.of(context).pop();

                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red[700],
                      content: Text(
                        "Please enter the Amount !",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                      }
                    },
                    child: Text(
                      "Add",
                      style: TextStyle(fontWeight: FontWeight.w600,
                      fontSize: 20,
                      ),
                    )))
          ],
        ));
  }
}

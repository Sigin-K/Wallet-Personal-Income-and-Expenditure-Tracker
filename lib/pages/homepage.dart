import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Wallet/controllers/db_helper.dart';
import 'package:Wallet/models/transaction_detail.dart';
import 'package:Wallet/pages/add_transaction.dart';
import 'package:Wallet/pages/settings.dart';
import 'package:Wallet/pages/widgets/dialog_input.dart';
import 'package:Wallet/static.dart' as Static;


class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime today= DateTime.now();
  dbHelper DbHelper = dbHelper();
  late Box box;
  late SharedPreferences preferences;
  int totalbalanceval = 0;
  int totalincome = 0;
  int totalexpense = 0;
  List<FlSpot> dataSet=[];

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

 List <FlSpot> getPlotPoints(List<TransactionDetail> entireData ){
  dataSet=[];
  // entireData.forEach((key, value) {

  //   if(value['type']=="Expense" && (value['date']as DateTime).month==today.month){

  //     dataSet.add(FlSpot(
  //       (value['date']as DateTime).day.toDouble(),
  //       (value['amount']as int).toDouble() ,
  //       )
  //       );
  //   }
  //  });
  List tempDataSet=[];
  for(TransactionDetail item in entireData){
    if(item.date.month==today.month && item.type=="Expense"){
      tempDataSet.add(item);
    }
  }

  tempDataSet.sort((a,b)=>a.date.day.compareTo(b.date.day));

  for (var i=0;i<tempDataSet.length;i++){
    dataSet.add(
    FlSpot(tempDataSet[i].date.day.toDouble(),tempDataSet[i].amount.toDouble())
  );
  }

  return dataSet;
  }

  TotalBalance(List<TransactionDetail> entireData) {
    totalexpense = 0;
    totalincome = 0;
    totalbalanceval = 0;

    for(TransactionDetail data in entireData){
      //if(data.date.month==today.month){
        if(data.type=="Income"){
          totalbalanceval+=data.amount;
          totalincome+=data.amount;
        }else{
          totalbalanceval-=data.amount;
          totalexpense+=data.amount;
        }
      //}
    }
  }

  getPreferences() async{
    preferences=await SharedPreferences.getInstance();
  }

  Future<List<TransactionDetail>> fetch() async{
    if(box.values.isEmpty){
      return Future.value([]);
    }else{
      List<TransactionDetail> items = [];
      box.toMap().values.forEach((element) {
        items.add(TransactionDetail(
          element['amount'] as int,
          element['date']as DateTime,
          element['note'], 
          element['type']));
      });
      return items;
    }
  }

@override
  void initState() {
    super.initState();
    getPreferences();
    box= Hive.box('money');

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      backgroundColor: Color(0xffe2e7ef),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(
              MaterialPageRoute(builder: (context) => AddTransaction()),
            )
                .whenComplete(() {
              setState(() {});
            });
          },
          backgroundColor: Static.PrimaryMaterialColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          child: Icon(
            Icons.add,
            size: 32.0,
          )),
      body: FutureBuilder<List<TransactionDetail>>(
        future: fetch(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error !"),
            );
          }
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return Center(
                child: Text("Press '+' to Add Values",
                style: TextStyle(fontSize: 15.0),)
              );
            }
             TotalBalance(snapshot.data!);
             getPlotPoints(snapshot.data!);
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.white70),
                              //padding: EdgeInsets.all(12.0),
                              child: Container(
                                child: CircleAvatar(
                                  maxRadius: 32,
                                  child: Image.asset(
                                    "assets/mymoney.png",
                                    width: 60.0,
                                  ),
                                ),
                              )),
                          SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            "Welcome ${preferences.getString('name')}",
                            style: TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.w700,
                                color: Colors.black),
                          ),
                          
                        ],
                      ),
                      
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: Colors.white70),
                        padding: EdgeInsets.all(12.0),
                        child:InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Settings()),
                            ).then((value){
                              setState(() {
                                
                              });
                            });
                          },
                           child: Icon(
                          Icons.settings,
                          size: 32.0,
                          color: Color(0xff3E454C),
                        ),
                       
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: EdgeInsets.all(12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Colors.pink.shade700,
                        Static.PrimaryMaterialColor,
                      ]),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 20.0,
                      horizontal: 8.0,
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Total Balance",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(),
                        Text(
                          "₹ $totalbalanceval",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              cardIncome(
                                totalincome.toString(),
                              ),
                              cardExpense(
                                totalexpense.toString(),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    "Expenditure Graph",
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                    ),
                  ),
                ),


               dataSet.length<2 || dataSet.isEmpty
               ? Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        spreadRadius: 5.0,
                        blurRadius: 6.0,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  padding:EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 40.0,
                  ),
                  margin:EdgeInsets.all(12.0
                  ),
                  //height: 400,




                  //plotting the graph




                  child:Text("Add minimum of 2 expenses to plot the graph",
                   style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                    ),),
                ):
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        spreadRadius: 5.0,
                        blurRadius: 6.0,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  padding:EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 40.0,
                  ),
                  margin:EdgeInsets.all(12.0
                  ),
                  height: 400,




                  //plotting the graph




                  child: LineChart(
                    LineChartData(
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots:  getPlotPoints(snapshot.data!),
                          isCurved: false,
                          barWidth: 2.0,
                          colors:[
                            Static.PrimaryMaterialColor,
                          ],
                          showingIndicators: [200, 200, 90, 10],
                                dotData: FlDotData(
                                  show: true,
                                ),
                        
                        ),
                      ]
                    ),
                  ),
                ),


                Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    "Recent Transactions",
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(), //disable scrolling of the ListView completely
                  itemCount: snapshot.data!.length+1,
                  itemBuilder: (context, index) {
                   TransactionDetail dataAtIndex;

                    try {
                       dataAtIndex=snapshot.data![index];
                      
                    } catch (e) {
                      return Container();
                      
                    }
                  
                    if (dataAtIndex.type == "Income") {
                      return IncomeTile(
                          dataAtIndex.amount, dataAtIndex.note,dataAtIndex.date,index);
                    } else {
                      return ExpsenseTile(
                          dataAtIndex.amount, dataAtIndex.note,dataAtIndex.date,index);
                    }
                  },
                ),
                SizedBox(
                  height: 60.0,
                )
              ],
            );
          } else {
            return Center(
              child: Text("Error !"),
            );
          }
        },
      ),
    );
  }

  Widget cardIncome(String value) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(
                25.0,
              )),
          padding: EdgeInsets.all(6.0),
          child: Icon(
            Icons.arrow_downward,
            size: 28.0,
            color: Colors.green,
          ),
          margin: EdgeInsets.only(right: 8.0),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Income",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14.0,
              ),
            ),
            Text(
              "₹" + value,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget cardExpense(String value) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(
                25.0,
              )),
          padding: EdgeInsets.all(6.0),
          child: Icon(
            Icons.arrow_upward,
            size: 28.0,
            color: Colors.red,
          ),
          margin: EdgeInsets.only(right: 8.0),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Expense",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14.0,
              ),
            ),
            Text(
              "₹" + value,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget ExpsenseTile(int value, String note, DateTime date,int index) {
    return InkWell(
      onLongPress: () async{
      bool? answer=await  showConfirmDialog(context, "Warning", "Confirm to delete");        
      
      if(answer!=null &&  answer){
        DbHelper.deleteData(index);
        setState(() {
          
        });

        }
      },
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Color(
            0xffced4eb,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
       child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.arrow_circle_up_outlined,
                    size: 25.0,
                    color: Colors.red[700],
                  ),
                  SizedBox(
                    width: 4.0,
                  ),
                  Text(
                    "Expense",
                    style: TextStyle(fontSize: 15.0),
                  )
                ],
              ),
              // Padding(
              //   padding: const EdgeInsets.all(16.0),
              //   child: Text(
              //     note,
              //     style: TextStyle(
              //       color: Colors.black,
              //     ),
              //   ),
              // ),
               Padding(
                 padding: const EdgeInsets.all(6.0),
                 child: Text(
                  "${date.day} ${months[date.month-1]}",
                  style: TextStyle(
                    color: Colors.grey[800],
                  ),
                             ),
               ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "- $value",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                note,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          )
        ],
      ),
      ),
    );
  }

  Widget IncomeTile(int value, String note, DateTime date,index) {
    return InkWell(
      onLongPress: () async{
      bool? answer=await  showConfirmDialog(context, "Warning", "Confirm to delete");        
      
      if(answer!=null &&  answer){
        DbHelper.deleteData(index);
        setState(() {
          
        });

        }
      },
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Color(
            0xffced4eb,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.arrow_circle_down_outlined,
                      size: 25.0,
                      color: Colors.green[700],
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      "Income",
                      style: TextStyle(fontSize: 15.0),
                    )
                  ],
                ),
                // Padding(
                //   padding: const EdgeInsets.all(16.0),
                //   child: Text(
                //     note,
                //     style: TextStyle(
                //       color: Colors.black,
                //     ),
                //   ),
                // ),
                 Padding(
                   padding: const EdgeInsets.all(6.0),
                   child: Text(
                    "${date.day} ${months[date.month-1]}",
                    style: TextStyle(
                      color: Colors.grey[800],
                    ),
                               ),
                 ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "+ $value",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  note,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}



import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sampleaura/controller/managehome.dart';
import 'package:sampleaura/model/response/manageagedistribution.dart';
import 'package:sampleaura/model/response/manageattendancedata.dart';
import 'package:sampleaura/model/response/managetenure.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../widget/dashboardcard.dart';




class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends StateMVC<Dashboard> {
  ManageHomeController? managehomeController;
  _DashboardState() : super(ManageHomeController()){
    managehomeController = controller as ManageHomeController?;

  }

  List<String>title = ['Attendance Today','Leaving this Month','Feedbacks Today','This Year Turnover Rate'];
  List<String>value = ['450','15','350','30'];
  List<double>percentage = [0.9,0.1,0.75,0.6];
  List<Color>backgroundColor =[Color(0xFFF0FDF7),Color(0xFFFEF7F7),Color(0xFFF0F6FF),Color(0xFFFDFBF1)];
  List<Color>progressColor =[Color(0xFF99CCB0),Color(0xFFF07575),Color(0xFF72A9F3),Color(0xFFD8C38C)];
  List<ChartData> chartData = [
    ChartData('2024-12-23', 1),
    ChartData('2024-12-24', 10),
    ChartData('2024-12-25', 20),
    ChartData('2024-12-25', 50),
    ChartData('2024-12-25', 40),


  ];
  List<ChartData> chartDataexists = [
    ChartData('Jan 24', 0),
    ChartData('Feb 24', 23),
    ChartData('March 24', 60),
    ChartData('Apr 24', 25),
    ChartData('May 24', 40),
    ChartData('Jun 24', 0),

  ];
  List<ChartData> chartDatamale = [
    ChartData('0-1', 9),
    ChartData('1-3', 1),
    // ChartData('4-5', 60),
    // ChartData('6-7', 25),
    // ChartData('8-9', 40),
    // ChartData('10-11', 0),

  ];
  List<ChartData> chartDatafemale = [

    ChartData('0-1', 3),
    ChartData('1-3', 0),
    // ChartData('2-3', 79),
    // ChartData('4-5', 60),
    // ChartData('6-7', 80),
    // ChartData('8-9', 20),
    // ChartData('10-11', 90),

  ];
  List<ChartDataage> chartage = [
    ChartDataage(20-30, 215, Color(0xFF92B0C6)),
    ChartDataage(30-40, 195, Color(0xFF9795BD)),
    ChartDataage(40-50, 175, Color(0xFF536493)),
    ChartDataage(50-60, 105, Color(0xFFD4BDAC)),


    
  ];
 
  List<String>department = ['Finance','Management','Support','Marketing'];
  List<int>male = [50,60,30,20];
  List<int>female = [50,40,70,80];
  List<double>feedbackpercentage = [0.9,0.7,0.3];
  List<Color>feedbackprogressColor =[Color(0xFF9795BD),Color(0xFFD4BDAC),Color(0xFF92B0C6)];List<String>feedbacktitle = ['Happy','Moderate','Sad',];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('Home');
    _loadAttendanceData();
    _loadAgeDistributionData();
    _loadLeaveReportData();
    _loadEmployeeTenureData();
    _loadEmployeeSatisfactionData();
}
 Future<void> _loadAttendanceData() async {
   await managehomeController?.fetchAttendanceData(); // Wait for data to be fetched
   print('Attendance Data : ${managehomeController?.attendanceData.length}'); // Safely access after fetching
 }
  Future<void> _loadAgeDistributionData()async {
    await managehomeController?.fetchAgeDistributionData(); // Wait for data to be fetched
    print('Attendance Data : ${managehomeController?.ageDistributionData.length}'); // Safely access after fetching
  }
  Future<void>_loadLeaveReportData()async {
    await managehomeController?.fetchLeaveReportData(); // Wait for data to be fetched
    print('LeaveReport Data : ${managehomeController?.leavereportData.length}'); // Safely access after fetching
  }
  Future<void>_loadEmployeeTenureData()async {
    await managehomeController?.fetchEmployeeTenureData(); // Wait for data to be fetched
    print('EmployeeTenure Data : ${managehomeController?.employeeTenureData.length}'); // Safely access after fetching
  }
  Future<void>_loadEmployeeSatisfactionData()async {
    await managehomeController?.fetchSatisfactionData(); // Wait for data to be fetched
    print('Satisfaction Data : ${managehomeController?.employeeSatisfactionData.length}'); // Safely access after fetching
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9FAFB),
        title: const Text(
          'Manage',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            color: Color(0xFF030303),
          ),
        ),
        elevation: 0,
      ),
      body:
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 4,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 130,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return AttendanceCard(
                    title: title[index],
                    count: value[index],
                    percentage: percentage[index],
                    backgroundColor: backgroundColor[index],
                    progressColor:progressColor[index],
                    elevation: 4.0,
                  );
                },
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Material(
                    elevation: 6,
                    shadowColor: Colors.grey.withOpacity(0.1), // Shadow color for elevation
                    borderRadius: BorderRadius.circular(8), // Ensures shadow follows rounded corners
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        Container(
                          height: 206,
                          width: 361,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 0.2,
                              color: const Color(0xFFE4E7EC),
                            ),
                            borderRadius: BorderRadius.circular(8), // Rounded corners
                            color: Colors.white, // Background color inside the container
                          ),
                          child:
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Attendance",style: TextStyle(fontSize: 14,color: Color(0xFF1D2939),fontFamily: 'Poppins'),),
                                  ),
                                  Spacer(),
                                  Row(
                                    children: [
                                    //  Text('18-12-2024 - 25-12-2024',style: TextStyle(fontFamily: 'Poppins',fontSize:12,color: Color(0xFF98A2B3)),),
                                    //  SizedBox(width: 2,),
                                    //  Padding(
                                    //    padding: const EdgeInsets.all(8.0),
                                    //    child: Container(height: 30,width: 30,decoration: BoxDecoration(
                                    //      border: Border.all(
                                    //        color:Color(0xFFE9E9E9)
                                    //      ),
                                    //      borderRadius: BorderRadius.circular(5)
                                    //    ),
                                    //    child: Icon(Icons.calendar_month_outlined,size:20 ,color: Color(0xFF1D2939),),),
                                    //
                                    //  )
                                    ],
                                  )
                                ],
                              ),
                              Flexible(
                                child: SfCartesianChart(
                                  plotAreaBorderWidth: 0,
                                  plotAreaBackgroundColor: Colors.transparent,
                                  plotAreaBorderColor: Colors.transparent,
                                  primaryYAxis: const NumericAxis(
                                    interval: 2,
                                    majorGridLines: MajorGridLines(width: 0),
                                    minorGridLines: MinorGridLines(width: 0),
                                    axisLine: AxisLine(width: 0),
                                    tickPosition: TickPosition.inside,
                                    majorTickLines: MajorTickLines(size: 0),
                                    minorTickLines: MinorTickLines(size: 0),
                                    labelStyle: TextStyle(fontSize: 10),
                                  ),
                                  primaryXAxis: const CategoryAxis(
                                    interval: 1,
                                    arrangeByIndex: true,
                                    majorGridLines: MajorGridLines(width: 0),
                                    axisLine: AxisLine(width: 0),
                                    majorTickLines: MajorTickLines(size: 0),
                                    labelStyle: TextStyle(fontSize: 10),// Hides major tick marks

                                  ),
                                  series: <CartesianSeries<AttendanceData, String>>[
                                    ColumnSeries<AttendanceData, String>(
                                      borderRadius: BorderRadius.circular(20),
                                      dataSource: managehomeController?.attendanceData.take(5).toList() ?? [],
                                      isTrackVisible: true,
                                      enableTooltip: true,
                                      opacity: 0.5,
                                      trackBorderWidth: 0.2,
                                      spacing: 0.7,
                                      color: const Color(0xFF536493),
                                      trackColor: const Color(0xFFE5E8F0),
                                      xValueMapper: (AttendanceData data, int index) => data.duration,
                                      yValueMapper: (AttendanceData data, int index) => data.totalEmployee,
                                    ),
                                  ],
                                ),
                              ),
                            ],

                          )
                        
                        
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 5,
                    shadowColor: Colors.grey.withOpacity(0.1),
                    color: Colors.transparent,
                child: Container(
                  height: 200,
                  width: 361,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 0.2,
                            color: const Color(0xFFE4E7EC),
                          ),
                          borderRadius: BorderRadius.circular(8), // Rounded corners
                          color: Colors.white, // Background color inside the container
                        ),


                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0,top: 16),
                        child: Text("Head Count",style: TextStyle(fontFamily: 'Poppins',fontSize:14 ),),
                      ),
                      SizedBox(height: 10,),
                      Flexible(
                        child: GridView.builder(
                          scrollDirection: Axis.horizontal,
                          //  physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: 3,
                              mainAxisExtent: 170

                          ),
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            return
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Material(
                                      elevation: 4,
                                      shadowColor: Colors.grey.withOpacity(0.1),
                                      color: Colors.transparent,
                                      child: Container(
                                        height: 134,
                                        width: 150,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 1,
                                            color: const Color(0xFFF2F4F7),
                                          ),
                                          borderRadius: BorderRadius.circular(8), // Rounded corners
                                          color: Colors.white, // Background color inside the container
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,

                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top:20.0,left: 15),
                                              child: Text(department[index],style: TextStyle(fontSize: 12,color: Color(0xFF1D2939),fontFamily: 'Poppins'),),
                                            ),
                                            SizedBox(height: 20,),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                height: 6,
                                                width: 130,
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                  children: [
                                                    Expanded(
                                                        flex: male[index],
                                                        child: Container(
                                                          height: 20,
                                                          decoration: BoxDecoration(
                                                              color: const Color(0xFF536493),
                                                              borderRadius: BorderRadius.circular(10)
                                                          ),

                                                        )),
                                                    Expanded(
                                                        flex: female[index],
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              color: Color(0xFFD4BDAC),
                                                              borderRadius: BorderRadius.circular(10)
                                                          ),
                                                        )),],
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 10,),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 20.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        height: 8,
                                                        width: 8,
                                                        decoration: BoxDecoration(
                                                          color: Color(0xFF536493),
                                                          borderRadius: BorderRadius.circular(20)

                                                        ),
                                                      ),
                                                      SizedBox(width:5,),
                                                      Text('Male',style: TextStyle(fontSize: 10,fontFamily: 'Poppins',),),
                                                      SizedBox(width: 59,),
                                                      Text(male[index].toString(),style: TextStyle(fontFamily: 'Poppins',fontSize: 10,fontWeight: FontWeight.w500),)
                                                    ],
                                                  ),
                                                  SizedBox(height: 8,),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        height: 8,
                                                        width: 8,
                                                        decoration: BoxDecoration(
                                                            color: Color(0xFFD4BDAC),
                                                            borderRadius: BorderRadius.circular(20)

                                                        ),
                                                      ),
                                                      SizedBox(width:5,),
                                                      Text('Female',style: TextStyle(fontSize: 10,fontFamily: 'Poppins',),),
                                                      SizedBox(width: 45,),
                                                      Text(female[index].toString(),style: TextStyle(fontFamily: 'Poppins',fontSize: 10,fontWeight: FontWeight.w500),)
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Material(
                    elevation: 6,
                    shadowColor: Colors.grey.withOpacity(0.1), // Shadow color for elevation
                    borderRadius: BorderRadius.circular(8), // Ensures shadow follows rounded corners
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        Container(
                            height: 206,
                            width: 361,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 0.2,
                                color: const Color(0xFFE4E7EC),
                              ),
                              borderRadius: BorderRadius.circular(8), // Rounded corners
                              color: Colors.white, // Background color inside the container
                            ),
                            child:
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Monthly Exists",style: TextStyle(fontSize: 14,color: Color(0xFF1D2939),fontFamily: 'Poppins'),),
                                    ),
                                    Spacer(),
                                    Row(
                                      children: [
                                        Text('Jan 2024 - Jun 2024',style: TextStyle(fontFamily: 'Poppins',fontSize:12,color: Color(0xFF98A2B3)),),
                                        SizedBox(width: 2,),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(height: 30,width: 30,decoration: BoxDecoration(
                                              border: Border.all(
                                                  color:Color(0xFFE9E9E9)
                                              ),
                                              borderRadius: BorderRadius.circular(5)
                                          ),
                                            child: Icon(Icons.calendar_month_outlined,size:20 ,color: Color(0xFF1D2939),),),

                                        )
                                      ],
                                    )
                                  ],
                                ),
                                Flexible(
                                  child: SfCartesianChart(
                                    plotAreaBorderWidth: 0,
                                  //  plotAreaBackgroundColor: Colors.transparent,
                                  //  plotAreaBorderColor: Colors.transparent,
                                    primaryYAxis: const NumericAxis(
                                      interval: 20,
                                      minorGridLines: MinorGridLines(width: 0.1),
                                      //tickPosition: TickPosition.inside,
                                      majorTickLines: MajorTickLines(size: 0),
                                      labelStyle: TextStyle(fontSize: 10),
                                    ),
                                    primaryXAxis: const CategoryAxis(
                                      interval: 0.1,
                                      arrangeByIndex: true,
                                      majorGridLines: MajorGridLines(width: 0),
                                      majorTickLines: MajorTickLines(size: 0),
                                      labelStyle: TextStyle(fontSize: 10),// Hides major tick marks

                                    ),
                                    series: <CartesianSeries<ChartData, String>>[
                                      SplineAreaSeries<ChartData, String>(
                                        dataSource:  chartDataexists,
                                       // enableTooltip: true,
                                          splineType: SplineType.cardinal,
                                          cardinalSplineTension: 0.9,
                                        opacity: 0.5,
                                          borderWidth: 2,
                                          borderColor: Color(0xFF001F77),
                                        borderDrawMode:BorderDrawMode.all ,
                                          xValueMapper: (ChartData data, int index) => data.x,
                                        yValueMapper: (ChartData data, int index) => data.y, gradient: LinearGradient(
                                          begin: Alignment.topCenter, end:Alignment.centerRight,
                                          stops: [0.5, 0.5], colors: [
                                        Colors.blue.withOpacity(.2),
                                        Colors.blue.withOpacity(.2)
                                      ])
                                      ),
                                    ],
                                  ),
                                ),
                              ],

                            )


                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Material(
                    elevation: 6,
                    shadowColor: Colors.grey.withOpacity(0.1), // Shadow color for elevation
                    borderRadius: BorderRadius.circular(8), // Ensures shadow follows rounded corners
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            height: 206,
                            width: 361,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 0.2,
                                color: const Color(0xFFE4E7EC),
                              ),
                              borderRadius: BorderRadius.circular(8), // Rounded corners
                              color: Colors.white, // Background color inside the container
                            ),
                            child:
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Text("Age Distribution",style: TextStyle(fontSize: 14,color: Color(0xFF1D2939),fontFamily: 'Poppins'),),
                                    ),

                                  ],
                                ),
                                Stack(
                                  children: [
                                    Positioned(
                                      top:60,
                                      left: 62,
                                      child: Container(
                                        height: 32,
                                        width: 60,
                                        child: Column(
                                          children: [
                                            Text("500",style: TextStyle(fontSize: 10,fontFamily: 'Poppins'),),
                                            Text("Employees",style: TextStyle(fontSize: 10,fontFamily: 'Poppins'),)
                                          ],
                                        ),
                                      ),
                                    ),
                                    Row(mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          height :155,
                                          width:180,
                                          child: Flexible(
                                            child: SfCircularChart(
                                              series: <CircularSeries<AgeDistribution, String>>[
                                                DoughnutSeries<AgeDistribution, String>(
                                                  dataSource:  managehomeController?.ageDistributionData,
                                                  xValueMapper: (AgeDistribution data, _) => data.age_group,
                                                  yValueMapper: (AgeDistribution  data, _) => data.employee_count,
                                                  // pointColorMapper: (AgeDistribution data, _) {
                                                  //
                                                  //   if (data.color != null && data.color!.isNotEmpty) {
                                                  //     // Ensure that the index does not go out of bounds by using modulo with the color list length
                                                  //     return data.color![_ % data.color!.length]; // Use color by index
                                                  //   }
                                                  //
                                                  // },
                                                  pointColorMapper: (AgeDistribution data , index) => data.color?[index],
                                                  innerRadius: '75%',

                                                   //explode: true,
                                                   //explodeAll: true,
                                                  radius: '85%',
                                                  cornerStyle: CornerStyle.bothCurve,

                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        SizedBox(
                                          height: 120,
                                          width: 100,

                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 8.0,),
                                            child: ListView.builder(
                                              itemCount :4,
                                                physics: const NeverScrollableScrollPhysics(),
                                              itemBuilder: (BuildContext context, int index) {
                                                var agedata  = managehomeController?.ageDistributionData[index];
                                                return  Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        height: 8,
                                                        width: 8,
                                                        decoration: BoxDecoration(
                                                            color: agedata!.color?[index],
                                                            borderRadius: BorderRadius.circular(20)

                                                        ),
                                                      ),
                                                      SizedBox(width: 5,),
                                                      Text(agedata!.age_group!,style: TextStyle(fontFamily: 'Poppins',fontSize: 10),)
                                                    ],
                                                  ),
                                                );
                                              },

                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],


                                ),
                              ],

                            )


                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Material(
                    elevation: 6,
                    shadowColor: Colors.grey.withOpacity(0.1), // Shadow color for elevation
                    borderRadius: BorderRadius.circular(8), // Ensures shadow follows rounded corners
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        Container(
                            height: 228,
                            width: 361,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 0.2,
                                color: const Color(0xFFE4E7EC),
                              ),
                              borderRadius: BorderRadius.circular(8), // Rounded corners
                              color: Colors.white, // Background color inside the container
                            ),
                            child:
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Leave Report",style: TextStyle(fontSize: 14,color: Color(0xFF1D2939),fontFamily: 'Poppins'),),
                                    ),

                                  ],
                                ),
                                SizedBox(
                                  width: 340,
                                  height: 140,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: 4,
                                      itemBuilder: (BuildContext context, int index) {
                                        var leavereport = managehomeController?.leavereportData[index];
                                        return Flexible(
                                          child:
                                          Padding(
                                            padding: const EdgeInsets.only(top:7.0,bottom: 10),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    LinearPercentIndicator(
                                                      backgroundColor: Color(0xFFF8F8FF),
                                                      width: MediaQuery.of(context).size.width - 70,
                                                      animation: true,
                                                      lineHeight: 10.0,
                                                      animationDuration: 2000,
                                                      percent: NumberFormat().parse(leavereport!.absentemployeecount_by_leavetype!).toDouble()/10,
                                                      barRadius: Radius.circular(10),
                                                      progressColor:leavereport.color?[index],
                                                    ),
                                                    Text('${leavereport!.absentemployeecount_by_leavetype!} / ${leavereport!.total_absent_employee_count!}',style: TextStyle(fontSize: 10,color: Color(0xFF98A2B3),fontFamily: 'Poppins'),)
                                                  ],
                                                ),

                                              ],
                                            ),
                                          ),
                                        );
                                      },


                                    ),
                                  ),
                                ),

                                SizedBox(
                                  height: 50,
                                  width: 320,
                                  child: ListView.builder(
                                    shrinkWrap: false,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: managehomeController?.leavereportData.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      var leavereport = managehomeController?.leavereportData[index];
                                    return  Padding(
                                      padding: const EdgeInsets.only(bottom: 30.0,left: 15),
                                      child: Row(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                height: 8,
                                                width: 8,
                                                decoration: BoxDecoration(
                                                    color: leavereport!.color?[index],
                                                    borderRadius: BorderRadius.circular(20)

                                                ),
                                              ),
                                              SizedBox(width: 4,),
                                              Text(leavereport.leavetypename!,style: TextStyle(fontFamily: 'Poppins',fontSize: 10),)
                                            ],
                                          ),


                                        ],
                                      ),
                                    );
                                  },


                                  ),
                                ),
                              ],

                            )


                        ),

                      ],
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Material(
                    elevation: 6,
                    shadowColor: Colors.grey.withOpacity(0.1), // Shadow color for elevation
                    borderRadius: BorderRadius.circular(8), // Ensures shadow follows rounded corners
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        Container(
                            height: 177,
                            width: 361,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 0.2,
                                color: const Color(0xFFE4E7EC),
                              ),
                              borderRadius: BorderRadius.circular(8), // Rounded corners
                              color: Colors.white, // Background color inside the container
                            ),
                            child:
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("Satisfaction Report",style: TextStyle(fontSize: 14,color: Color(0xFF1D2939),fontFamily: 'Poppins'),),
                                    ),
                                  ],
                                ),
                                Expanded(child:   GridView.builder(scrollDirection: Axis.horizontal,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1,crossAxisSpacing: 2,mainAxisExtent: 100),
                                  itemCount: managehomeController?.employeeSatisfactionData.length,
                                  itemBuilder: (BuildContext context, int index) {
                                  var satisfactiondata = managehomeController?.employeeSatisfactionData[index];
                                    return  Padding(
                                      padding: const EdgeInsets.only(left: 25.0,top: 20),
                                      child: SizedBox(
                                        height: 70,
                                        width: 70 ,
                                        child: Column(
                                          children: [
                                            CircularPercentIndicator(
                                                startAngle: 0,
                                                circularStrokeCap: CircularStrokeCap.round,
                                                radius: 35.0,
                                                lineWidth: 7.0,
                                                percent:satisfactiondata!.percentage!,
                                                backgroundColor: Color(0xFFF8F8FF),
                                                //center: Text("${(feedbackpercentage[index] * 100).toInt()}%"),
                                                center: Text("${satisfactiondata.percentage! * 100.toInt()}%"),
                                                progressColor: feedbackprogressColor[index]
                                            ),
                                            Text(feedbacktitle[index])
                                          ],
                                        ),

                                      ),
                                    );


                                  },


                                ))



                              ],

                            )


                        ),

                      ],
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Material(
                    elevation: 6,
                    shadowColor: Colors.grey.withOpacity(0.1), // Shadow color for elevation
                    borderRadius: BorderRadius.circular(8), // Ensures shadow follows rounded corners
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        Container(
                            height: 206,
                            width: 361,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 0.2,
                                color: const Color(0xFFE4E7EC),
                              ),
                              borderRadius: BorderRadius.circular(8), // Rounded corners
                              color: Colors.white, // Background color inside the container
                            ),
                            child:
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Employee Tenure",style: TextStyle(fontSize: 14,color: Color(0xFF1D2939),fontFamily: 'Poppins',fontWeight: FontWeight.w500),),
                                    ),

                                  ],
                                ),
                      Flexible(
                        child: SfCartesianChart(
                          plotAreaBorderWidth: 0,

                          // Primary X Axis
                          primaryXAxis: const CategoryAxis(
                            interval: 1,
                            majorGridLines: MajorGridLines(width: 0),
                            majorTickLines: MajorTickLines(size: 0),
                            labelStyle: TextStyle(fontSize: 10),
                          ),

                          // Primary Y Axis for the first spline series
                          primaryYAxis: const NumericAxis(


                            interval: 1,
                            labelStyle: TextStyle(fontSize: 10),
                          ),


                          series: <CartesianSeries>[
                            // First spline series
                            // SplineSeries<ChartData, String>(
                            //   name: 'Male',
                            //   dataSource: chartDatafemale,
                            //   xValueMapper: (ChartData data, int index) => data.x,
                            //   yValueMapper: (ChartData data, int index) => data.y,
                            //
                            //   markerSettings: const MarkerSettings(isVisible: true),
                            //   color: Color(0xFF536493),
                            // ),
                            SplineSeries<EmployeeTenure, String>(
                              name: 'Male',
                              dataSource: managehomeController?.employeeTenureData,
                              xValueMapper: (EmployeeTenure data, int index) => data.years_of_service,
                              yValueMapper: (EmployeeTenure data, int index) => data.male_count,

                              markerSettings: const MarkerSettings(isVisible: true),
                              color: Color(0xFF536493),
                            ),

                            // Second spline series
                            // SplineSeries<ChartData, String>(
                            //   name: 'Female',
                            //   dataSource: chartDatamale,
                            //   xValueMapper: (ChartData data, int index) => data.x,
                            //   yValueMapper: (ChartData data, int index) => data.y,
                            //   markerSettings: const MarkerSettings(isVisible: true),
                            //   color: Color(0xFFD4BDAC),
                            // ),
                            SplineSeries<EmployeeTenure, String>(
                              name: 'Female',
                              dataSource: managehomeController?.employeeTenureData,
                              xValueMapper: (EmployeeTenure data, int index) => data.years_of_service,
                              yValueMapper: (EmployeeTenure data, int index) => data.female_count,

                              markerSettings: const MarkerSettings(isVisible: true),
                              color: Color(0xFFD4BDAC),
                            ),
                          ],

                          // Legend
                          legend: Legend(isVisible: true, position: LegendPosition.bottom),
                        ),
                      ),

                              ],

                            )


                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
class ChartData {
  final String x;
  final double y;
  ChartData(this.x,this.y);
}
class ChartDataage {
  final int x;
  final int y;
  final Color color;
  ChartDataage(this.x,this.y,this.color);
}

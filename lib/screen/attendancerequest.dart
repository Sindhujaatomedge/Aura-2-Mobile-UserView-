import 'dart:async';
import 'dart:ui';

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';



import '../controller/attendance.dart';
import '../controller/leaverequest.dart';
import '../widget/requestshimmer.dart';
import 'homescreen.dart';
class Attendancerequest extends StatefulWidget {
  const Attendancerequest({super.key});

  @override
  _AttendancerequestState createState() => _AttendancerequestState();
}

class _AttendancerequestState extends StateMVC<Attendancerequest> with SingleTickerProviderStateMixin {
  TabController? tabController;
  late  AttendanceController _con;

  _AttendancerequestState(): super( AttendanceController()){
    _con = controller as  AttendanceController;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController =TabController(length: 3, vsync: this);
    setState(() {
      _con.fetchResponseattendancerequest();
    });
    _con.requestattendancelistlog.length;
    Timer(const Duration(seconds: 2),(){
      setState((){
        _con.isLoading =false;

      });


    });

  }
  String formatDate(String date) {
    final parsedDate = DateTime.parse(date); // Parse the ISO 8601 string
    final formattedDate = DateFormat('dd MMM, yyyy').format(parsedDate); // Format to desired output
    return formattedDate;
  }
  String formatedTime(String time) {
    String trimtime = time.trim();

    final parsedTime = DateFormat("HH:mm:ss").parse(trimtime);
    String formattedTime = DateFormat("hh:mm a").format(parsedTime);

    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color((0xFFF9FAFB)),
      child: DefaultTabController(
        length: 6,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text('Regularize Requests'),
            leading: InkWell(child: const Icon(Icons.arrow_back_ios, color: Colors.black),onTap: (){Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()));
            },),

          ), body:  SafeArea(
            child:
            DefaultTabController(
              length: 3,
              child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ButtonsTabBar(
                    radius: 12,
                    labelSpacing: 20,

                    contentPadding: EdgeInsets.symmetric(horizontal: 25),
                    backgroundColor: const Color(0xFFE0EDFF),
                    unselectedBackgroundColor: Colors.transparent,
                    unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400,fontFamily: 'Poppins',fontSize: 14,color:Color(0xFF98A2B3)),
                    labelStyle:
                    const TextStyle(color: Color(0xFF030303), fontWeight: FontWeight.w400,fontFamily: 'Poppins',fontSize: 14),
                    tabs: const [
                      Tab(
                        text: "Awaiting",
                      ),
                      Tab(
                        text: "Approved",
                      ),
                      Tab(
                        text: "Rejected",
                      ),

                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: <Widget>[
                        _con.isLoading ? 
                        ListView.builder(
                           itemCount:4,
                          itemBuilder: (BuildContext context, int index) {
                            return const Requestshimmer();
                            },
                        )
                            : _con.requestattendancelistlog.isEmpty? Container(
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/images/norecord.svg',
                            ),
                          ),
                        ):
                        ListView.builder(
                          itemCount: _con.requestattendancelistlog.length,
                         itemBuilder: (BuildContext context, int index) {
                           var Attendancerequest = _con.requestattendancelistlog[index];
                           return Attendancerequest.status == 'pending'?
                             Padding(
                             padding: const EdgeInsets.all(8.0),
                             child:
                             InkWell(
                               onTap: (){
                                 print(Attendancerequest.id);
                                 showModalBottomSheet(
                                     context: context,
                                     isScrollControlled: true,

                                     builder: (context) {
                                       return FractionallySizedBox(
                                         heightFactor: 0.92,
                                         child:  Padding(
                                           padding: const EdgeInsets.all(7.0),
                                           child: Column(
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                             children: [
                                               Center(
                                                 child: Container(
                                                   height: 4,
                                                   width: 60,
                                                   decoration: BoxDecoration(
                                                       color: Color(0xFF98A2B3),
                                                       borderRadius: BorderRadius.circular(8)
                                                   ),

                                                 ),
                                               ),
                                               Padding(
                                                 padding:  EdgeInsets.only(top: 20.0),
                                                 child:
                                                // Center(child: Image.asset('assets/images/profile.png', width: 50, height: 50)),
                                                 Center(child: Image.network(Attendancerequest.avatar, width: 50, height: 50)),
                                               ),
                                               Column(
                                                 children: [
                                                   //Center(child: Text(Attendancerequest.username,style: TextStyle(fontSize:16,fontFamily: 'Poppins',fontWeight: FontWeight.w500,color: Color(0xFF1D2939) ),)),
                                                   Center(child: Text(Attendancerequest.name,style: TextStyle(fontSize:16,fontFamily: 'Poppins',fontWeight: FontWeight.w500,color: Color(0xFF1D2939) ),)),
                                                   Center(child: Text('Ux Designer',style: TextStyle(fontSize:12,fontFamily: 'Poppins',fontWeight: FontWeight.w400,color: Color(0xFF98A2B3) ),)),

                                                   Row(
                                                     mainAxisAlignment: MainAxisAlignment.center,
                                                     children: [
                                                       Center(child: Image.asset('assets/images/calendar1.png',height: 22,width: 22,color: Color(0xFF98A2B3),)),
                                                       SizedBox(
                                                         width: 3,
                                                       ),
                                                      // Center(child: Text(Attendancerequest.noOfDays.toString() + ' Days',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: Color(0xFF98A2B3),fontFamily: 'Poppins'),)),
                                                     ],
                                                   ),

                                                   Padding(
                                                     padding: const EdgeInsets.all(8.0),
                                                     child:
                                                     Row(
                                                       mainAxisAlignment: MainAxisAlignment.center, children: [
                                                       Center(child: Image.asset('assets/images/calendar2.png',height: 22,width: 22,color: Color(0xFF98A2B3),)),
                                                         SizedBox(width: 5,),
                                                         //Text('21 January, 2024 - 22 January, 2024',style: TextStyle(color: Color(0xFF98A2B3),fontSize: 14,fontFamily: 'Poppins'),)
                                                       //  Center(child: Text('${formatDate(Attendancerequest.checkin.toString())} - ${formatDate(Attendancerequest.checkout.toString())}',style: TextStyle(color: Color(0xFF98A2B3),fontSize: 12,fontFamily: 'Poppins'),))
                                                       ],
                                                     ),
                                                   ),

                                                 ],
                                               ),
                                               SizedBox(height: 16),
                                               Center(
                                                 child: Container(
                                                   height: 112,
                                                   width: 321,
                                                   decoration: BoxDecoration(
                                                     border: Border.all(
                                                       color: Color(0xFFE4E7EC)
                                                     ),
                                                     borderRadius: BorderRadius.circular(10)

                                                   ),
                                                   child: Padding(
                                                     padding: const EdgeInsets.all(8.0),
                                                     child: Text(
                                                       Attendancerequest.comments!,
                                                     ),
                                                   ),
                                                 ),
                                               ),
                                               SizedBox(height: 10),
                                               Padding(
                                                 padding: const EdgeInsets.only(left: 15.0),
                                                 child: Text("Attachment",style: TextStyle(
                                                   fontSize: 12,
                                                     fontFamily: 'Poppins',

                                                     color: Color(0xFF98A2B3)),),
                                               ),
                                               SizedBox(
                                                 height: 10,
                                               ),
                                               Row(
                                                 mainAxisAlignment: MainAxisAlignment.center,
                                                 children: [
                                                   Container(
                                                     width: 155,
                                                     height: 55,
                                                     child: Row(
                                                       children: [
                                                         Container(
                                                           decoration: BoxDecoration(
                                                             borderRadius: BorderRadius.circular(5),
                                                             border: Border.all(
                                                               color: Color(0xFFE9E9E9),
                                                             )
                                                           ),
                                                             child: Row(
                                                               mainAxisAlignment: MainAxisAlignment.start,
                                                               children: [
                                                                 Padding(
                                                                   padding: const EdgeInsets.only(left: 5.0),
                                                                    child: Image.asset('assets/images/document.png',height: 22,width: 22,color: Color(0xFF98A2B3),),
                                                                 ),
                                                                 SizedBox(
                                                                   width: 10,
                                                                 ),
                                                                 Column(
                                                                   mainAxisAlignment: MainAxisAlignment.start,
                                                                   crossAxisAlignment: CrossAxisAlignment.start,
                                                                   children: [
                                                                     Padding(
                                                                       padding: const EdgeInsets.only(top:8.0,right: 8),
                                                                       child: Text("Prescription2.pdf",style: TextStyle(fontSize: 12,fontWeight:FontWeight.w400,fontFamily: 'Poppins'),),
                                                                     ),
                                                                     Padding(
                                                                       padding: const EdgeInsets.only(right:10),
                                                                       child: Text("100kb",style: TextStyle(fontSize: 10,fontWeight:FontWeight.w400,fontFamily: 'Poppins',color: Color(0xFF98A2B3)),),
                                                                     ),

                                                                   ],
                                                                 )
                                                               ],
                                                             )
                                                         ),
                                                       ],
                                                     ),
                                                   ),
                                                   SizedBox(
                                                     width: 10,
                                                   ),
                                                   Container(
                                                     width: 155,
                                                     height: 55,
                                                     child: Row(
                                                       children: [
                                                         Row(
                                                           children: [
                                                             Container(
                                                                 decoration: BoxDecoration(
                                                                     borderRadius: BorderRadius.circular(5),
                                                                     border: Border.all(
                                                                       color: Color(0xFFE9E9E9),
                                                                     )
                                                                 ),
                                                                 child: Row(
                                                                   // mainAxisAlignment: MainAxisAlignment.start,
                                                                   children: [
                                                                     Padding(
                                                                       padding: const EdgeInsets.only(left: 5.0),
                                                                       child: Image.asset('assets/images/document.png',height: 22,width: 22,color: Color(0xFF98A2B3),),
                                                                     ),
                                                                     SizedBox(
                                                                       width: 10,
                                                                     ),
                                                                     Column(
                                                                       mainAxisAlignment: MainAxisAlignment.start,
                                                                       crossAxisAlignment: CrossAxisAlignment.start,
                                                                       children: [
                                                                         Padding(
                                                                           padding: const EdgeInsets.only(top:8.0,right: 8),
                                                                           child: Text("Prescription2.pdf",style: TextStyle(fontSize: 12,fontWeight:FontWeight.w400,fontFamily: 'Poppins'),),
                                                                         ),
                                                                         Padding(
                                                                           padding: const EdgeInsets.only(right:10),
                                                                           child: Text("100kb",style: TextStyle(fontSize: 10,fontWeight:FontWeight.w400,fontFamily: 'Poppins',color: Color(0xFF98A2B3)),),
                                                                         ),

                                                                       ],
                                                                     )
                                                                   ],
                                                                 )
                                                             ),
                                                           ],
                                                         )],


                                                     ),
                                                   ),
                                                 ],
                                               ),
                                               SizedBox(height: 10,),
                                               Center(
                                                 child: Container(
                                                   height: 112,
                                                   width: 321,
                                                   decoration: BoxDecoration(
                                                       border: Border.all(
                                                           color: Color(0xFFE4E7EC)
                                                       ),
                                                       borderRadius: BorderRadius.circular(10)

                                                   ),
                                                   child: Padding(
                                                     padding: const EdgeInsets.all(8.0),
                                                     child: Text('Your Comment',style: TextStyle(fontSize:12,fontFamily:'Poppins',color: Color(0xFF98A2B3),),),
                                                   ),
                                                 ),
                                               ),
                                               SizedBox(
                                                 height: 15,
                                               ),
                                               Padding(
                                                 padding: const EdgeInsets.only(left: 20.0),
                                                 child: Row(
                                                   children: [
                                                     ConstrainedBox(
                                                       constraints: BoxConstraints.tightFor(width: 151, height: 42),
                                                       child: ElevatedButton.icon(

                                                           onPressed: (){},
                                                           style: ElevatedButton.styleFrom(
                                                             backgroundColor: Color(0xFFE4E7EC),
                                                             elevation: .1,

                                                             shape: RoundedRectangleBorder(
                                                               borderRadius: BorderRadius.circular(4.0),
                                                             ),
                                                           ),
                                                           label:  Row(
                                                             mainAxisAlignment: MainAxisAlignment.center,
                                                             children: [
                                                               Image.asset('assets/images/close1.png',height: 22,width: 22,color: Color(0xFF030303),),
                                                               SizedBox(width: 5,),
                                                               Center(child: const Text("Reject",style: TextStyle(fontFamily:'Poppins',fontSize: 14,fontWeight: FontWeight.w400,color: Color(0xFF030303)),)),
                                                             ],
                                                           )),
                                                     ),
                                                     SizedBox(
                                                       width: 10,
                                                     ),
                                                     ConstrainedBox(
                                                       constraints: BoxConstraints.tightFor(width: 151, height: 42),
                                                       child: ElevatedButton.icon(

                                                           onPressed: (){},
                                                           style: ElevatedButton.styleFrom(
                                                             backgroundColor: Color(0xFF004AAD),
                                                             elevation: .1,

                                                             shape: RoundedRectangleBorder(
                                                               borderRadius: BorderRadius.circular(4.0),
                                                             ),
                                                           ),
                                                           label:  Row(
                                                             mainAxisAlignment: MainAxisAlignment.center,
                                                             children: [
                                                               Image.asset('assets/images/tick.png',height: 22,width: 22,color: Color(0xFFFCFCFC),),
                                                               SizedBox(width: 5,),
                                                               Center(child: const Text("Approve",style: TextStyle(fontFamily:'Poppins',fontSize: 14,fontWeight: FontWeight.w400,color: Colors.white),)),
                                                             ],
                                                           )),
                                                     ),
                                                   ],
                                                 ),
                                               ),
                                             ],
                                           ),
                                         ),
                                       );
                                     }
                                   // builder: (BuildContext context) {
                                   //   return _buildBottomSheetContent();
                                   // },
                                 );
                                 // buildScrollablesheet();
                               },
                               child: Column(
                                 children: [
                                   Stack(
                                       children: [
                                         Positioned(
                                           top:6,
                                           right: -25,
                                           child: Container(
                                             height: 130,
                                             width: 130,
                                             child: Image.asset('assets/images/attendancebg.png',),
                                           ),
                                         ),
                                         Container(
                                           decoration: BoxDecoration(
                                               border: Border.all(
                                                 width: .7,
                                                 color: Color(0xFFE4E7EC),

                                               ),
                                               color: Colors.transparent,
                                               borderRadius: BorderRadius.circular(8)
                                           ),
                                           height: 218,
                                           width: 361,
                                           child: Column(
                                             children: [

                                               Row(
                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                                 children: [
                                                   Padding(
                                                     padding: const EdgeInsets.only(top: 20.0,left: 20),
                                                     child:
                                                    // Image.asset('assets/images/profile.png', width: 40, height: 40),
                                                     Image.network(Attendancerequest.avatar, width: 40, height: 40),
                                                   ),

                                                    Padding(
                                                     padding: EdgeInsets.only(top:5),
                                                     child: SizedBox(
                                                       height: 50,
                                                       width: 250,
                                                       child: ListTile(

                                                         //title: Text(Attendancerequest.username,style: TextStyle(fontSize: 16,fontFamily: 'Poppins',fontWeight: FontWeight.w600,color: Color(0xFF1D2939)),),
                                                         title: Text(Attendancerequest.name,style: TextStyle(fontSize: 16,fontFamily: 'Poppins',fontWeight: FontWeight.w600,color: Color(0xFF1D2939)),),

                                                         subtitle: Text('Ux Designer',style: TextStyle(fontSize:12,fontFamily: 'Poppins',fontWeight: FontWeight.w400,color: Color(0xFF98A2B3) ),),
                                                       ),
                                                     ),
                                                   )
                                                 ],
                                               ),


                                               Padding(
                                                 padding: const EdgeInsets.only(top:10.0,left: 20),
                                                 child: Row(
                                                   children: [
                                                     Row(
                                                       mainAxisAlignment: MainAxisAlignment.center,
                                                       children: [
                                                         Center(child: Image.asset('assets/images/calendar1.png',height: 20,width: 20,color: Color(0xFF98A2B3),)),
                                                         SizedBox(
                                                           width: 4,
                                                         ),
                                                         Center(child:   Text('${formatDate(Attendancerequest.checkindate.toString())} - ${formatDate(Attendancerequest.checkoutdate.toString())}',style: TextStyle(color: Color( 0xFF030303),fontSize: 12,fontFamily: 'Poppins'),),),
                                                       ],
                                                     ),



                                                   ],
                                                 ),
                                               ),
                                               Padding(
                                                 padding:
                                                 const EdgeInsets
                                                     .only(
                                                     top: 10.0,
                                                     left: 20),
                                                 child: Row(
                                                   children: [
                                                     Row(
                                                       mainAxisAlignment: MainAxisAlignment.center,
                                                       children: [
                                                         Center(child: Image.asset('assets/images/calendar1.png',height: 20,width: 20,color: Color(0xFF98A2B3),)),
                                                         SizedBox(
                                                           width: 4,
                                                         ),
                                                         Center(
                                                             child:
                                                             Text(
                                                               "${formatedTime(Attendancerequest.checkintime)} - ${Attendancerequest.checkouttime.isEmpty ? " " : formatedTime(Attendancerequest.checkouttime)}",
                                                               style: TextStyle(
                                                                   color: Color(
                                                                       0xFF030303),
                                                                   fontSize:
                                                                   12,
                                                                   fontFamily:
                                                                   'Poppins'),
                                                             ))
                                                       ],
                                                     ),

                                                   ],
                                                 ),
                                               ),


                                               SizedBox(
                                                 height: 20,
                                               ),
                                               Padding(
                                                 padding: const EdgeInsets.only(left: 20.0),
                                                 child: Row(
                                                   children: [
                                                     ConstrainedBox(
                                                       constraints: BoxConstraints.tightFor(width: 151, height: 42),
                                                       child: ElevatedButton.icon(

                                                           onPressed: (){},
                                                           style: ElevatedButton.styleFrom(
                                                             backgroundColor: Color(0xFFE4E7EC),
                                                             elevation: .1,

                                                             shape: RoundedRectangleBorder(
                                                               borderRadius: BorderRadius.circular(4.0),
                                                             ),
                                                           ),
                                                           label:  Row(
                                                             mainAxisAlignment: MainAxisAlignment.center,
                                                             children: [
                                                               Image.asset('assets/images/close1.png',height: 22,width: 22,color: Color(0xFF030303),),
                                                               SizedBox(width: 5,),
                                                               Center(child: const Text("Reject",style: TextStyle(fontFamily:'Poppins',fontSize: 14,fontWeight: FontWeight.w400,color: Color(0xFF030303)),)),
                                                             ],
                                                           )),
                                                     ),
                                                     SizedBox(
                                                       width: 10,
                                                     ),
                                                     ConstrainedBox(
                                                       constraints: BoxConstraints.tightFor(width: 151, height: 42),
                                                       child: ElevatedButton.icon(

                                                           onPressed: (){
                                                             _con.approve(Attendancerequest.id,Attendancerequest);
                                                             setState((){
                                                               _con.fetchResponseattendancerequest();

                                                             });
                                                           },
                                                           style: ElevatedButton.styleFrom(
                                                             backgroundColor: Color(0xFF004AAD),
                                                             elevation: .1,

                                                             shape: RoundedRectangleBorder(
                                                               borderRadius: BorderRadius.circular(4.0),
                                                             ),
                                                           ),
                                                           label:  Row(
                                                             mainAxisAlignment: MainAxisAlignment.center,
                                                             children: [
                                                               Image.asset('assets/images/tick.png',height: 22,width: 22,color: Color(0xFFFCFCFC),),
                                                               SizedBox(width: 5,),
                                                               Center(child: const Text("Approve",style: TextStyle(fontFamily:'Poppins',fontSize: 14,fontWeight: FontWeight.w400,color: Colors.white),)),
                                                             ],
                                                           )),
                                                     ),
                                                   ],
                                                 ),
                                               ),
                                             ],

                                           ),


                                         ),
                                       ]

                                   ),
                                 ],

                               ),
                             ),
                           ) :Center(child: Container()) ;
                         },


                       ),
                        _con.isLoading ? Center(child: CircularProgressIndicator()):
                        _con.requestattendancelistlog.isEmpty? Container(
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/images/norecord.svg',
                            ),
                          ),
                        ):

                        ListView.builder(
                          itemCount: _con.requestattendancelistlog.length,
                          itemBuilder: (BuildContext context, int index) {
                            var Attendancerequest = _con.requestattendancelistlog[index];


                            return Attendancerequest.status == 'approved' ?
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                InkWell(
                                  onTap: (){
                                    print(Attendancerequest.id);
                                    showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,

                                        builder: (context) {
                                          return FractionallySizedBox(
                                            heightFactor: 0.92,
                                            child:  Padding(
                                              padding: const EdgeInsets.all(7.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Center(
                                                    child: Container(
                                                      height: 4,
                                                      width: 60,
                                                      decoration: BoxDecoration(
                                                          color: Color(0xFF98A2B3),
                                                          borderRadius: BorderRadius.circular(8)
                                                      ),

                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:  EdgeInsets.only(top: 20.0),
                                                    child:
                                                    Center(child: Image.asset('assets/images/profile.png', width: 50, height: 50)),
                                                    // Center(child: Image.network(Attendancerequest.avatar, width: 50, height: 50)),
                                                  ),
                                                  Column(
                                                    children: [
                                                      //Center(child: Text(Attendancerequest.username,style: TextStyle(fontSize:16,fontFamily: 'Poppins',fontWeight: FontWeight.w500,color: Color(0xFF1D2939) ),)),
                                                      Center(child: Text(Attendancerequest.name,style: TextStyle(fontSize:16,fontFamily: 'Poppins',fontWeight: FontWeight.w500,color: Color(0xFF1D2939) ),)),
                                                      Center(child: Text('Ux Designer',style: TextStyle(fontSize:12,fontFamily: 'Poppins',fontWeight: FontWeight.w400,color: Color(0xFF98A2B3) ),)),

                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Center(child: Image.asset('assets/images/calendar1.png',height: 22,width: 22,color: Color(0xFF98A2B3),)),
                                                          SizedBox(
                                                            width: 3,
                                                          ),
                                                          // Center(child: Text(Attendancerequest.noOfDays.toString() + ' Days',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: Color(0xFF98A2B3),fontFamily: 'Poppins'),)),
                                                        ],
                                                      ),

                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child:
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center, children: [
                                                          Center(child: Image.asset('assets/images/calendar2.png',height: 22,width: 22,color: Color(0xFF98A2B3),)),
                                                          SizedBox(width: 5,),
                                                          //Text('21 January, 2024 - 22 January, 2024',style: TextStyle(color: Color(0xFF98A2B3),fontSize: 14,fontFamily: 'Poppins'),)
                                                          //  Center(child: Text('${formatDate(Attendancerequest.checkin.toString())} - ${formatDate(Attendancerequest.checkout.toString())}',style: TextStyle(color: Color(0xFF98A2B3),fontSize: 12,fontFamily: 'Poppins'),))
                                                        ],
                                                        ),
                                                      ),

                                                    ],
                                                  ),
                                                  SizedBox(height: 16),
                                                  Center(
                                                    child: Container(
                                                      height: 112,
                                                      width: 321,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: Color(0xFFE4E7EC)
                                                          ),
                                                          borderRadius: BorderRadius.circular(10)

                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text(
                                                          Attendancerequest.comments!,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 15.0),
                                                    child: Text("Attachment",style: TextStyle(
                                                        fontSize: 12,
                                                        fontFamily: 'Poppins',

                                                        color: Color(0xFF98A2B3)),),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        width: 155,
                                                        height: 55,
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(5),
                                                                    border: Border.all(
                                                                      color: Color(0xFFE9E9E9),
                                                                    )
                                                                ),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(left: 5.0),
                                                                      child: Image.asset('assets/images/document.png',height: 22,width: 22,color: Color(0xFF98A2B3),),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(top:8.0,right: 8),
                                                                          child: Text("Prescription2.pdf",style: TextStyle(fontSize: 12,fontWeight:FontWeight.w400,fontFamily: 'Poppins'),),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(right:10),
                                                                          child: Text("100kb",style: TextStyle(fontSize: 10,fontWeight:FontWeight.w400,fontFamily: 'Poppins',color: Color(0xFF98A2B3)),),
                                                                        ),

                                                                      ],
                                                                    )
                                                                  ],
                                                                )
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Container(
                                                        width: 155,
                                                        height: 55,
                                                        child: Row(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Container(
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(5),
                                                                        border: Border.all(
                                                                          color: Color(0xFFE9E9E9),
                                                                        )
                                                                    ),
                                                                    child: Row(
                                                                      // mainAxisAlignment: MainAxisAlignment.start,
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(left: 5.0),
                                                                          child: Image.asset('assets/images/document.png',height: 22,width: 22,color: Color(0xFF98A2B3),),
                                                                        ),
                                                                        SizedBox(
                                                                          width: 10,
                                                                        ),
                                                                        Column(
                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(top:8.0,right: 8),
                                                                              child: Text("Prescription2.pdf",style: TextStyle(fontSize: 12,fontWeight:FontWeight.w400,fontFamily: 'Poppins'),),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(right:10),
                                                                              child: Text("100kb",style: TextStyle(fontSize: 10,fontWeight:FontWeight.w400,fontFamily: 'Poppins',color: Color(0xFF98A2B3)),),
                                                                            ),

                                                                          ],
                                                                        )
                                                                      ],
                                                                    )
                                                                ),
                                                              ],
                                                            )],


                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10,),
                                                  Center(
                                                    child: Container(
                                                      height: 112,
                                                      width: 321,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: Color(0xFFE4E7EC)
                                                          ),
                                                          borderRadius: BorderRadius.circular(10)

                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('Your Comment',style: TextStyle(fontSize:12,fontFamily:'Poppins',color: Color(0xFF98A2B3),),),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 20.0),
                                                    child: Row(
                                                      children: [
                                                        ConstrainedBox(
                                                          constraints: BoxConstraints.tightFor(width: 151, height: 42),
                                                          child: ElevatedButton.icon(

                                                              onPressed: (){},
                                                              style: ElevatedButton.styleFrom(
                                                                backgroundColor: Color(0xFFE4E7EC),
                                                                elevation: .1,

                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(4.0),
                                                                ),
                                                              ),
                                                              label:  Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Image.asset('assets/images/close1.png',height: 22,width: 22,color: Color(0xFF030303),),
                                                                  SizedBox(width: 5,),
                                                                  Center(child: const Text("Reject",style: TextStyle(fontFamily:'Poppins',fontSize: 14,fontWeight: FontWeight.w400,color: Color(0xFF030303)),)),
                                                                ],
                                                              )),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        ConstrainedBox(
                                                          constraints: BoxConstraints.tightFor(width: 151, height: 42),
                                                          child: ElevatedButton.icon(

                                                              onPressed: (){},
                                                              style: ElevatedButton.styleFrom(
                                                                backgroundColor: Color(0xFF004AAD),
                                                                elevation: .1,

                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(4.0),
                                                                ),
                                                              ),
                                                              label:  Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Image.asset('assets/images/tick.png',height: 22,width: 22,color: Color(0xFFFCFCFC),),
                                                                  SizedBox(width: 5,),
                                                                  Center(child: const Text("Approve",style: TextStyle(fontFamily:'Poppins',fontSize: 14,fontWeight: FontWeight.w400,color: Colors.white),)),
                                                                ],
                                                              )),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }
                                      // builder: (BuildContext context) {
                                      //   return _buildBottomSheetContent();
                                      // },
                                    );
                                    // buildScrollablesheet();
                                  },
                                  child: Column(
                                    children: [
                                      Stack(
                                          children: [
                                            Positioned(
                                              top:6,
                                              right: -25,
                                              child: Container(
                                                height: 130,
                                                width: 130,
                                                child: Image.asset('assets/images/attendancebg.png',),
                                              ),
                                            ),
                                            Positioned(
                                              top: 40,
                                              right: 15,
                                              child: Container(
                                                height: 28,
                                                width: 78,
                                                decoration: BoxDecoration(
                                                    color: Color(0xFF65BD95),
                                                    borderRadius:
                                                    BorderRadius.circular(4)),
                                                child: Center(
                                                    child: Text(Attendancerequest.status,
                                                        style: TextStyle(
                                                            fontFamily: 'Poppins',
                                                            fontSize: 12,
                                                            fontWeight:
                                                            FontWeight.w400,
                                                            color:
                                                            Colors.white))),
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    width: .7,
                                                    color: Color(0xFFE4E7EC),

                                                  ),
                                                  color: Colors.transparent,
                                                  borderRadius: BorderRadius.circular(8)
                                              ),
                                              height: 152,
                                              width: 361,
                                              child: Column(
                                                children: [

                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(top: 20.0,left: 20),
                                                        child:
                                                        // Image.asset('assets/images/profile.png', width: 40, height: 40),
                                                        Image.network(Attendancerequest.avatar, width: 40, height: 40),
                                                      ),




                                                      Padding(
                                                        padding: EdgeInsets.only(top:5),
                                                        child: SizedBox(
                                                          height: 50,
                                                          width: 250,
                                                          child: ListTile(

                                                            //title: Text(Attendancerequest.username,style: TextStyle(fontSize: 16,fontFamily: 'Poppins',fontWeight: FontWeight.w600,color: Color(0xFF1D2939)),),
                                                            title: Text(Attendancerequest.name,style: TextStyle(fontSize: 16,fontFamily: 'Poppins',fontWeight: FontWeight.w600,color: Color(0xFF1D2939)),),

                                                            subtitle: Text('Ux Designer',style: TextStyle(fontSize:12,fontFamily: 'Poppins',fontWeight: FontWeight.w400,color: Color(0xFF98A2B3) ),),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),


                                                  Padding(
                                                    padding: const EdgeInsets.only(top:10.0,left: 20),
                                                    child: Row(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Center(child: Image.asset('assets/images/calendar1.png',height: 20,width: 20,color: Color(0xFF98A2B3),)),
                                                            SizedBox(
                                                              width: 4,
                                                            ),
                                                            Center(child:   Text('${formatDate(Attendancerequest.checkindate.toString())} - ${formatDate(Attendancerequest.checkoutdate.toString())}',style: TextStyle(color: Color( 0xFF030303),fontSize: 12,fontFamily: 'Poppins'),),),
                                                          ],
                                                        ),



                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets
                                                        .only(
                                                        top: 10.0,
                                                        left: 20),
                                                    child: Row(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Center(child: Image.asset('assets/images/calendar1.png',height: 20,width: 20,color: Color(0xFF98A2B3),)),
                                                            SizedBox(
                                                              width: 4,
                                                            ),
                                                            Center(
                                                                child:
                                                                Text(
                                                                  "${formatedTime(Attendancerequest.checkintime)} - ${Attendancerequest.checkouttime.isEmpty ? " " : formatedTime(Attendancerequest.checkouttime)}",
                                                                  style: TextStyle(
                                                                      color: Color(
                                                                          0xFF030303),
                                                                      fontSize:
                                                                      12,
                                                                      fontFamily:
                                                                      'Poppins'),
                                                                ))
                                                          ],
                                                        ),

                                                      ],
                                                    ),
                                                  ),



                                                ],

                                              ),


                                            ),
                                          ]

                                      ),
                                    ],

                                  ),
                                ),
                              ) : Center(child: Container());
                          },


                        ),

                        _con.isLoading ? Center(child: CircularProgressIndicator()):
                        _con.requestattendancelistlog.isEmpty?
                        Container(
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/images/norecord.svg',
                            ),
                          ),
                        ): ListView.builder(

                          itemCount: _con.requestattendancelistlog.length,
                          itemBuilder: (BuildContext context, int index) {
                            var Attendancerequest = _con.requestattendancelistlog[index];


                            return Attendancerequest.status == 'rejected' ?
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                              InkWell(
                                onTap: (){
                                  print(Attendancerequest.id);
                                  showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,

                                      builder: (context) {
                                        return FractionallySizedBox(
                                          heightFactor: 0.92,
                                          child:  Padding(
                                            padding: const EdgeInsets.all(7.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Center(
                                                  child: Container(
                                                    height: 4,
                                                    width: 60,
                                                    decoration: BoxDecoration(
                                                        color: Color(0xFF98A2B3),
                                                        borderRadius: BorderRadius.circular(8)
                                                    ),

                                                  ),
                                                ),
                                                Padding(
                                                  padding:  EdgeInsets.only(top: 20.0),
                                                  child:
                                                  Center(child: Image.asset('assets/images/profile.png', width: 50, height: 50)),
                                                  // Center(child: Image.network(Attendancerequest.avatar, width: 50, height: 50)),
                                                ),
                                                Column(
                                                  children: [
                                                    //Center(child: Text(Attendancerequest.username,style: TextStyle(fontSize:16,fontFamily: 'Poppins',fontWeight: FontWeight.w500,color: Color(0xFF1D2939) ),)),
                                                    Center(child: Text(Attendancerequest.name,style: TextStyle(fontSize:16,fontFamily: 'Poppins',fontWeight: FontWeight.w500,color: Color(0xFF1D2939) ),)),
                                                    Center(child: Text('Ux Designer',style: TextStyle(fontSize:12,fontFamily: 'Poppins',fontWeight: FontWeight.w400,color: Color(0xFF98A2B3) ),)),

                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Center(child: Image.asset('assets/images/calendar1.png',height: 22,width: 22,color: Color(0xFF98A2B3),)),
                                                        SizedBox(
                                                          width: 3,
                                                        ),
                                                        // Center(child: Text(Attendancerequest.noOfDays.toString() + ' Days',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: Color(0xFF98A2B3),fontFamily: 'Poppins'),)),
                                                      ],
                                                    ),

                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child:
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.center, children: [
                                                        Center(child: Image.asset('assets/images/calendar2.png',height: 22,width: 22,color: Color(0xFF98A2B3),)),
                                                        SizedBox(width: 5,),
                                                        //Text('21 January, 2024 - 22 January, 2024',style: TextStyle(color: Color(0xFF98A2B3),fontSize: 14,fontFamily: 'Poppins'),)
                                                        //  Center(child: Text('${formatDate(Attendancerequest.checkin.toString())} - ${formatDate(Attendancerequest.checkout.toString())}',style: TextStyle(color: Color(0xFF98A2B3),fontSize: 12,fontFamily: 'Poppins'),))
                                                      ],
                                                      ),
                                                    ),

                                                  ],
                                                ),
                                                SizedBox(height: 16),
                                                Center(
                                                  child: Container(
                                                    height: 112,
                                                    width: 321,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Color(0xFFE4E7EC)
                                                        ),
                                                        borderRadius: BorderRadius.circular(10)

                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text(
                                                        Attendancerequest.comments!,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 15.0),
                                                  child: Text("Attachment",style: TextStyle(
                                                      fontSize: 12,
                                                      fontFamily: 'Poppins',

                                                      color: Color(0xFF98A2B3)),),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: 155,
                                                      height: 55,
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(5),
                                                                  border: Border.all(
                                                                    color: Color(0xFFE9E9E9),
                                                                  )
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(left: 5.0),
                                                                    child: Image.asset('assets/images/document.png',height: 22,width: 22,color: Color(0xFF98A2B3),),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Column(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(top:8.0,right: 8),
                                                                        child: Text("Prescription2.pdf",style: TextStyle(fontSize: 12,fontWeight:FontWeight.w400,fontFamily: 'Poppins'),),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(right:10),
                                                                        child: Text("100kb",style: TextStyle(fontSize: 10,fontWeight:FontWeight.w400,fontFamily: 'Poppins',color: Color(0xFF98A2B3)),),
                                                                      ),

                                                                    ],
                                                                  )
                                                                ],
                                                              )
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Container(
                                                      width: 155,
                                                      height: 55,
                                                      child: Row(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Container(
                                                                  decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(5),
                                                                      border: Border.all(
                                                                        color: Color(0xFFE9E9E9),
                                                                      )
                                                                  ),
                                                                  child: Row(
                                                                    // mainAxisAlignment: MainAxisAlignment.start,
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(left: 5.0),
                                                                        child: Image.asset('assets/images/document.png',height: 22,width: 22,color: Color(0xFF98A2B3),),
                                                                      ),
                                                                      SizedBox(
                                                                        width: 10,
                                                                      ),
                                                                      Column(
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Padding(
                                                                            padding: const EdgeInsets.only(top:8.0,right: 8),
                                                                            child: Text("Prescription2.pdf",style: TextStyle(fontSize: 12,fontWeight:FontWeight.w400,fontFamily: 'Poppins'),),
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsets.only(right:10),
                                                                            child: Text("100kb",style: TextStyle(fontSize: 10,fontWeight:FontWeight.w400,fontFamily: 'Poppins',color: Color(0xFF98A2B3)),),
                                                                          ),

                                                                        ],
                                                                      )
                                                                    ],
                                                                  )
                                                              ),
                                                            ],
                                                          )],


                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 10,),
                                                Center(
                                                  child: Container(
                                                    height: 112,
                                                    width: 321,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Color(0xFFE4E7EC)
                                                        ),
                                                        borderRadius: BorderRadius.circular(10)

                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text('Your Comment',style: TextStyle(fontSize:12,fontFamily:'Poppins',color: Color(0xFF98A2B3),),),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 20.0),
                                                  child: Row(
                                                    children: [
                                                      ConstrainedBox(
                                                        constraints: BoxConstraints.tightFor(width: 151, height: 42),
                                                        child: ElevatedButton.icon(

                                                            onPressed: (){},
                                                            style: ElevatedButton.styleFrom(
                                                              backgroundColor: Color(0xFFE4E7EC),
                                                              elevation: .1,

                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(4.0),
                                                              ),
                                                            ),
                                                            label:  Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Image.asset('assets/images/close1.png',height: 22,width: 22,color: Color(0xFF030303),),
                                                                SizedBox(width: 5,),
                                                                Center(child: const Text("Reject",style: TextStyle(fontFamily:'Poppins',fontSize: 14,fontWeight: FontWeight.w400,color: Color(0xFF030303)),)),
                                                              ],
                                                            )),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      ConstrainedBox(
                                                        constraints: BoxConstraints.tightFor(width: 151, height: 42),
                                                        child: ElevatedButton.icon(

                                                            onPressed: (){},
                                                            style: ElevatedButton.styleFrom(
                                                              backgroundColor: Color(0xFF004AAD),
                                                              elevation: .1,

                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(4.0),
                                                              ),
                                                            ),
                                                            label:  Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Image.asset('assets/images/tick.png',height: 22,width: 22,color: Color(0xFFFCFCFC),),
                                                                SizedBox(width: 5,),
                                                                Center(child: const Text("Approve",style: TextStyle(fontFamily:'Poppins',fontSize: 14,fontWeight: FontWeight.w400,color: Colors.white),)),
                                                              ],
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                    // builder: (BuildContext context) {
                                    //   return _buildBottomSheetContent();
                                    // },
                                  );
                                  // buildScrollablesheet();
                                },
                                child: Column(
                                  children: [
                                    Stack(
                                        children: [
                                          Positioned(
                                            top:6,
                                            right: -25,
                                            child: Container(
                                              height: 130,
                                              width: 130,
                                              child: Image.asset('assets/images/attendancebg.png',),
                                            ),
                                          ),
                                          Positioned(
                                            top: 40,
                                            right: 15,
                                            child: Container(
                                              height: 28,
                                              width: 78,
                                              decoration: BoxDecoration(
                                                  color: Color(0xFF65BD95),
                                                  borderRadius:
                                                  BorderRadius.circular(4)),
                                              child: Center(
                                                  child: Text(Attendancerequest.status,
                                                      style: TextStyle(
                                                          fontFamily: 'Poppins',
                                                          fontSize: 12,
                                                          fontWeight:
                                                          FontWeight.w400,
                                                          color:
                                                          Colors.white))),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  width: .7,
                                                  color: Color(0xFFE4E7EC),

                                                ),
                                                color: Colors.transparent,
                                                borderRadius: BorderRadius.circular(8)
                                            ),
                                            height: 152,
                                            width: 361,
                                            child: Column(
                                              children: [

                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 20.0,left: 20),
                                                      child:
                                                      // Image.asset('assets/images/profile.png', width: 40, height: 40),
                                                      Image.network(Attendancerequest.avatar, width: 40, height: 40),
                                                    ),




                                                    Padding(
                                                      padding: EdgeInsets.only(top:5),
                                                      child: SizedBox(
                                                        height: 50,
                                                        width: 250,
                                                        child: ListTile(

                                                          //title: Text(Attendancerequest.username,style: TextStyle(fontSize: 16,fontFamily: 'Poppins',fontWeight: FontWeight.w600,color: Color(0xFF1D2939)),),
                                                          title: Text(Attendancerequest.name,style: TextStyle(fontSize: 16,fontFamily: 'Poppins',fontWeight: FontWeight.w600,color: Color(0xFF1D2939)),),

                                                          subtitle: Text('Ux Designer',style: TextStyle(fontSize:12,fontFamily: 'Poppins',fontWeight: FontWeight.w400,color: Color(0xFF98A2B3) ),),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),


                                                Padding(
                                                  padding: const EdgeInsets.only(top:10.0,left: 20),
                                                  child: Row(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Center(child: Image.asset('assets/images/calendar1.png',height: 20,width: 20,color: Color(0xFF98A2B3),)),
                                                          SizedBox(
                                                            width: 4,
                                                          ),
                                                          Center(child:   Text('${formatDate(Attendancerequest.checkindate.toString())} - ${formatDate(Attendancerequest.checkoutdate.toString())}',style: TextStyle(color: Color( 0xFF030303),fontSize: 12,fontFamily: 'Poppins'),),),
                                                        ],
                                                      ),



                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets
                                                      .only(
                                                      top: 10.0,
                                                      left: 20),
                                                  child: Row(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Center(child: Image.asset('assets/images/calendar1.png',height: 20,width: 20,color: Color(0xFF98A2B3),)),
                                                          SizedBox(
                                                            width: 4,
                                                          ),
                                                          Center(
                                                              child:
                                                              Text(
                                                                "${formatedTime(Attendancerequest.checkintime)} - ${Attendancerequest.checkouttime.isEmpty ? " " : formatedTime(Attendancerequest.checkouttime)}",
                                                                style: TextStyle(
                                                                    color: Color(
                                                                        0xFF030303),
                                                                    fontSize:
                                                                    12,
                                                                    fontFamily:
                                                                    'Poppins'),
                                                              ))
                                                        ],
                                                      ),

                                                    ],
                                                  ),
                                                ),



                                              ],

                                            ),


                                          ),
                                        ]

                                    ),
                                  ],

                                ),
                              ),
                            ) : Center(child: Container());
                          },


                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

        ),
      ),
    );
  }


}


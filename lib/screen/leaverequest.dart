import 'dart:async';
import 'dart:ui';

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:intl/intl.dart';


import '../controller/leaverequest.dart';
class Leaverequest extends StatefulWidget {
  const Leaverequest({super.key});

  @override
  _LeaverequestState createState() => _LeaverequestState();
}

class _LeaverequestState extends StateMVC<Leaverequest> with SingleTickerProviderStateMixin {
  TabController? tabController;
  late LeaveRequestController _con;

  _LeaverequestState(): super(LeaveRequestController()){
    _con = controller as LeaveRequestController;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController =TabController(length: 3, vsync: this);
    _con.fetchResponseleave();
    _con.leaverequest.length;
    Timer(const Duration(seconds: 2),(){
      setState((){
        _con.isLoading =false;

      });


    });

  }
  String formatDate(String date) {
    final parsedDate = DateTime.parse(date); // Parse the ISO 8601 string
    final formattedDate = DateFormat('dd MMMM, yyyy').format(parsedDate); // Format to desired output
    return formattedDate;
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
            title: const Text('Leave Request'),
            leading: const Icon(Icons.arrow_back_ios),

          ), body:  SafeArea(
            child: DefaultTabController(
              length: 3,
              child: Column(
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
                        _con.isLoading ? Center(child: CircularProgressIndicator()):
                        _con.leaverequest.isEmpty? Container(
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/images/norecord.svg',
                            ),
                          ),
                        ): ListView.builder(

                         itemCount: _con.leaverequest.length,
                         itemBuilder: (BuildContext context, int index) {
                           var leaverequest = _con.leaverequest[index];


                           return
                             Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: InkWell(
                               onTap: (){
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
                                                 padding: const EdgeInsets.only(top: 20.0),
                                                 child: Center(child: Image.asset('assets/images/profile.png', width: 50, height: 50)),
                                               ),
                                               Column(
                                                 children: [
                                                   Center(child: Text('Leo Rhiel Maddsen',style: TextStyle(fontSize:16,fontFamily: 'Poppins',fontWeight: FontWeight.w500,color: Color(0xFF1D2939) ),)),
                                                   Center(child: Text('Ux Designer',style: TextStyle(fontSize:12,fontFamily: 'Poppins',fontWeight: FontWeight.w400,color: Color(0xFF98A2B3) ),)),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                   Row(
                                                     mainAxisAlignment: MainAxisAlignment.center,

                                                     children: [
                                                       Center(child: Image.asset('assets/images/beach.png',height: 22,width: 22,color: Color(0xFF030303),)),
                                                       SizedBox(width: 5,),
                                                       Center(child: Text('Casual Leave',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: Color(0xFF030303),fontFamily: 'Poppins'),)),

                                                     ],
                                                   ),
                                                   SizedBox(
                                                     height: 10,
                                                   ),
                                                   Row(
                                                     mainAxisAlignment: MainAxisAlignment.center,
                                                     children: [
                                                       Center(child: Image.asset('assets/images/calendar1.png',height: 22,width: 22,color: Color(0xFF98A2B3),)),
                                                       SizedBox(
                                                         width: 3,
                                                       ),
                                                       Center(child: Text(leaverequest.noOfDays.toString() + ' Days',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: Color(0xFF98A2B3),fontFamily: 'Poppins'),)),
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
                                                         Center(child: Text('${formatDate(leaverequest.startDate.toString())} - ${formatDate(leaverequest.endDate.toString())}',style: TextStyle(color: Color(0xFF98A2B3),fontSize: 12,fontFamily: 'Poppins'),))
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
                                                       leaverequest.reason,
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
                                             height: 156,
                                             width: 156,
                                             child: Image.asset('assets/images/beachbg.png',),
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
                                           height: 242,
                                           width: 361,
                                           child: Column(
                                             children: [

                                               Row(
                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                                 children: [
                                                   Padding(
                                                     padding: const EdgeInsets.only(top: 20.0,left: 20),
                                                     child: Image.asset('assets/images/profile.png', width: 40, height: 40),
                                                   ),

                                                    Padding(
                                                     padding: EdgeInsets.only(top:5),
                                                     child: SizedBox(
                                                       height: 50,
                                                       width: 250,
                                                       child: ListTile(

                                                         title: Text(leaverequest.userId,style: TextStyle(fontSize: 16,fontFamily: 'Poppins',fontWeight: FontWeight.w600,color: Color(0xFF1D2939)),),

                                                         subtitle: Text('Ux Designer',style: TextStyle(fontSize:12,fontFamily: 'Poppins',fontWeight: FontWeight.w400,color: Color(0xFF98A2B3) ),),
                                                       ),
                                                     ),
                                                   )
                                                 ],
                                               ),
                                               Padding(
                                                 padding: const EdgeInsets.only(top:25.0,left: 20),
                                                 child: Row(
                                                   crossAxisAlignment: CrossAxisAlignment.start,
                                                   children: [
                                                     Image.asset('assets/images/beach.png',height: 22,width: 22,color: Color(0xFF030303),),
                                                     const Padding(
                                                       padding: EdgeInsets.only(left: 8.0),
                                                       child: Text('Casual Leave',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: Color(0xFF030303),fontFamily: 'Poppins'),),
                                                     )
                                                   ],
                                                 ),

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
                                                           width: 3,
                                                         ),
                                                         Center(child: Text(leaverequest.noOfDays.toString() + '  Days',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400,color: Color(0xFF98A2B3),fontFamily: 'Poppins'),)),
                                                       ],
                                                     ),


                                                    // Text('${formatDate(leaverequest.startDate.toString())} - ${formatDate(leaverequest.endDate.toString())}',style: TextStyle(color: Color(0xFF98A2B3),fontSize: 12,fontFamily: 'Poppins'),)
                                                   ],
                                                 ),
                                               ),
                                               Padding(
                                                 padding: const EdgeInsets.only(top:10.0,left: 20),
                                                 child: Row(
                                                   children: [
                                                     Row(
                                                       mainAxisAlignment: MainAxisAlignment.center,
                                                       children: [
                                                         Center(child: Image.asset('assets/images/calendar2.png',height: 20,width: 20,color: Color(0xFF98A2B3),)),
                                                         SizedBox(
                                                           width: 3,
                                                         ),
                                                         Center(child: Text('${formatDate(leaverequest.startDate.toString())} - ${formatDate(leaverequest.endDate.toString())}',style: TextStyle(color: Color(0xFF98A2B3),fontSize: 12,fontFamily: 'Poppins'),))
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
                                       ]

                                   ),
                                 ],

                               ),
                             ),
                           );
                         },


                       ),



                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: (){
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,

                                builder: (context) {
                                  return FractionallySizedBox(
                                    heightFactor: 0.8,
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
                                            padding: const EdgeInsets.only(top: 30.0 ,left: 13),
                                            child: Row(
                                              children: [
                                                Image.asset('assets/images/profile.png', width: 50, height: 50),
                                                Spacer(),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    height: 28,
                                                    width: 78,
                                                    decoration: BoxDecoration(
                                                        color: Color(0xFF65BD95),
                                                        borderRadius: BorderRadius.circular(4)
                                                    ),

                                                    child: Center(child: Text("Approved",style: TextStyle(fontFamily:'Poppins',fontSize: 12,fontWeight: FontWeight.w400,color: Colors.white))),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.only(left: 13.0),
                                            child: Column(
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Leo Rhiel Maddsen',style: TextStyle(fontSize:16,fontFamily: 'Poppins',fontWeight: FontWeight.w500,color: Color(0xFF1D2939) ),),
                                                Text('Ux Designer',style: TextStyle(fontSize:12,fontFamily: 'Poppins',fontWeight: FontWeight.w400,color: Color(0xFF98A2B3) ),),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 8.0),
                                                  child: Row(


                                                    children: [
                                                      Image.asset('assets/images/beach.png',height: 22,width: 22,color: Color(0xFF030303),),
                                                      SizedBox(width: 5,),
                                                      Text('Casual Leave',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: Color(0xFF030303),fontFamily: 'Poppins'),),

                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 8.0),
                                                  child: Row(

                                                    children: [
                                                      Image.asset('assets/images/calendar1.png',height: 22,width: 22,color: Color(0xFF98A2B3),),
                                                      SizedBox(
                                                        width: 3,
                                                      ),
                                                      Text('2 Days',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: Color(0xFF98A2B3),fontFamily: 'Poppins'),),
                                                    ],
                                                  ),
                                                ),

                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child:
                                                  Row(
                                                    children: [
                                                    Image.asset('assets/images/calendar2.png',height: 22,width: 22,color: Color(0xFF98A2B3),),
                                                    SizedBox(width: 5,),
                                                    Text('21 January, 2024 - 22 January, 2024',style: TextStyle(color: Color(0xFF98A2B3),fontSize: 14,fontFamily: 'Poppins'),)
                                                   // Center(child: Text('${formatDate(leaverequest.startDate.toString())} - ${formatDate(leaverequest.endDate.toString())}',style: TextStyle(color: Color(0xFF98A2B3),fontSize: 12,fontFamily: 'Poppins'),))
                                                  ],
                                                  ),
                                                ),

                                              ],
                                            ),
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
                                                //child: Text(leaverequest.reason,),
                                                child: Text("Reason"),
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
                                                              child: Image.asset('assets/images/document.png',height: 22,width: 22,),
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
                                                                  child: Image.asset('assets/images/document.png',height: 22,width: 22,),
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
                                      right: -35,
                                      child: Container(
                                        height: 175,
                                        width: 191,
                                        child: Image.asset('assets/images/beachbg.png',),
                                      ),
                                    ),
                                    Positioned(
                                      top: 75,
                                      right: 30,
                                      child: Container(
                                        height: 28,
                                        width: 78,
                                       decoration: BoxDecoration(
                                          color: Color(0xFF65BD95),
                                         borderRadius: BorderRadius.circular(4)
                                       ),

                                        child: Center(child: Text("Approved",style: TextStyle(fontFamily:'Poppins',fontSize: 12,fontWeight: FontWeight.w400,color: Colors.white))),
                                      ),
                                      // child: ElevatedButton.icon(
                                      //
                                      //     onPressed: (){},
                                      //     style: ElevatedButton.styleFrom(
                                      //       backgroundColor: Color(0xFF65BD95),
                                      //       elevation: .5,
                                      //
                                      //       shape: RoundedRectangleBorder(
                                      //         borderRadius: BorderRadius.circular(4.0),
                                      //       ),
                                      //     ),
                                      //     label:  const Text("Approved",style: TextStyle(fontFamily:'Poppins',fontSize: 12,fontWeight: FontWeight.w400,color: Colors.white),)),
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
                                      height: 175,
                                      width: 361,
                                      child: Column(
                                        children: [

                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(top: 20.0,left: 20),
                                                child: Image.asset('assets/images/profile.png', width: 40, height: 40),
                                              ),

                                              Padding(
                                                padding: EdgeInsets.only(top:5),
                                                child: SizedBox(
                                                  height: 50,
                                                  width: 250,
                                                  child: ListTile(

                                                    title: Text('Jhon',style: TextStyle(fontSize: 16,fontFamily: 'Poppins',fontWeight: FontWeight.w600,color: Color(0xFF1D2939)),),

                                                    subtitle: Text('Ux Designer',style: TextStyle(fontSize:12,fontFamily: 'Poppins',fontWeight: FontWeight.w400,color: Color(0xFF98A2B3) ),),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top:25.0,left: 20),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Image.asset('assets/images/beach.png',height: 22,width: 22,color: Color(0xFF030303),),
                                                const Padding(
                                                  padding: EdgeInsets.only(left: 8.0),
                                                  child: Text('Casual Leave',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: Color(0xFF030303),fontFamily: 'Poppins'),),
                                                )
                                              ],
                                            ),

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
                                                      width: 3,
                                                    ),
                                                   // Center(child: Text(leaverequest.noOfDays.toString() + '  Days',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400,color: Color(0xFF98A2B3),fontFamily: 'Poppins'),)),
                                                    Center(child: Text('1  Days',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400,color: Color(0xFF98A2B3),fontFamily: 'Poppins'),)),
                                                  ],
                                                ),


                                                // Text('${formatDate(leaverequest.startDate.toString())} - ${formatDate(leaverequest.endDate.toString())}',style: TextStyle(color: Color(0xFF98A2B3),fontSize: 12,fontFamily: 'Poppins'),)
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top:10.0,left: 20),
                                            child: Row(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Center(child: Image.asset('assets/images/calendar2.png',height: 20,width: 20,color: Color(0xFF98A2B3),)),
                                                    SizedBox(
                                                      width: 3,
                                                    ),
                                                    Center(child: Text('21 January, 2024 - 22 January, 2024',style: TextStyle(color: Color(0xFF98A2B3),fontSize: 14,fontFamily: 'Poppins'),))
                                                   // Center(child: Text('${formatDate(leaverequest.startDate.toString())} - ${formatDate(leaverequest.endDate.toString())}',style: TextStyle(color: Color(0xFF98A2B3),fontSize: 12,fontFamily: 'Poppins'),))
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
                      ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: (){
                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,

                                  builder: (context) {
                                    return FractionallySizedBox(
                                      heightFactor: 0.8,
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
                                              padding: const EdgeInsets.only(top: 30.0 ,left: 13),
                                              child: Row(
                                                children: [
                                                  Image.asset('assets/images/profile.png', width: 50, height: 50),
                                                  Spacer(),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Container(
                                                      height: 28,
                                                      width: 78,
                                                      decoration: BoxDecoration(
                                                          color: Color(0xFFEA7971),
                                                          borderRadius: BorderRadius.circular(4)
                                                      ),

                                                      child: Center(child: Text("Rejected",style: TextStyle(fontFamily:'Poppins',fontSize: 12,fontWeight: FontWeight.w400,color: Colors.white))),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(left: 13.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('Leo Rhiel Maddsen',style: TextStyle(fontSize:16,fontFamily: 'Poppins',fontWeight: FontWeight.w500,color: Color(0xFF1D2939) ),),
                                                  Text('Ux Designer',style: TextStyle(fontSize:12,fontFamily: 'Poppins',fontWeight: FontWeight.w400,color: Color(0xFF98A2B3) ),),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 8.0),
                                                    child: Row(


                                                      children: [
                                                        Image.asset('assets/images/beach.png',height: 22,width: 22,color: Color(0xFF030303),),
                                                        SizedBox(width: 5,),
                                                        Text('Casual Leave',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: Color(0xFF030303),fontFamily: 'Poppins'),),

                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 8.0),
                                                    child: Row(

                                                      children: [
                                                        Image.asset('assets/images/calendar1.png',height: 22,width: 22,color: Color(0xFF98A2B3),),
                                                        SizedBox(
                                                          width: 3,
                                                        ),
                                                        Text('2 Days',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: Color(0xFF98A2B3),fontFamily: 'Poppins'),),
                                                      ],
                                                    ),
                                                  ),

                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child:
                                                    Row(
                                                      children: [
                                                        Image.asset('assets/images/calendar2.png',height: 22,width: 22,color: Color(0xFF98A2B3),),
                                                        SizedBox(width: 5,),
                                                        Text('21 January, 2024 - 22 January, 2024',style: TextStyle(color: Color(0xFF98A2B3),fontSize: 14,fontFamily: 'Poppins'),)
                                                        // Center(child: Text('${formatDate(leaverequest.startDate.toString())} - ${formatDate(leaverequest.endDate.toString())}',style: TextStyle(color: Color(0xFF98A2B3),fontSize: 12,fontFamily: 'Poppins'),))
                                                      ],
                                                    ),
                                                  ),

                                                ],
                                              ),
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
                                                  //child: Text(leaverequest.reason,),
                                                  child: Text("Reason"),
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
                                                                child: Image.asset('assets/images/document.png',height: 22,width: 22,),
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
                                                                    child: Image.asset('assets/images/document.png',height: 22,width: 22,),
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
                                        right: -35,
                                        child: Container(
                                          height: 175,
                                          width: 191,
                                          child: Image.asset('assets/images/beachbg.png',),
                                        ),
                                      ),
                                      Positioned(
                                        top: 75,
                                        right: 30,
                                        child: Container(
                                          height: 28,
                                          width: 78,
                                          decoration: BoxDecoration(
                                              color: Color(0xFFEA7971),
                                              borderRadius: BorderRadius.circular(4)
                                          ),

                                          child: Center(child: Text("Rejected",style: TextStyle(fontFamily:'Poppins',fontSize: 12,fontWeight: FontWeight.w400,color: Colors.white))),
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
                                        height: 175,
                                        width: 361,
                                        child: Column(
                                          children: [

                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 20.0,left: 20),
                                                  child: Image.asset('assets/images/profile.png', width: 40, height: 40),
                                                ),

                                                Padding(
                                                  padding: EdgeInsets.only(top:5),
                                                  child: SizedBox(
                                                    height: 50,
                                                    width: 250,
                                                    child: ListTile(

                                                      title: Text('Jhon',style: TextStyle(fontSize: 16,fontFamily: 'Poppins',fontWeight: FontWeight.w600,color: Color(0xFF1D2939)),),

                                                      subtitle: Text('Ux Designer',style: TextStyle(fontSize:12,fontFamily: 'Poppins',fontWeight: FontWeight.w400,color: Color(0xFF98A2B3) ),),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top:25.0,left: 20),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Image.asset('assets/images/beach.png',height: 22,width: 22,color: Color(0xFF030303),),
                                                  const Padding(
                                                    padding: EdgeInsets.only(left: 8.0),
                                                    child: Text('Casual Leave',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: Color(0xFF030303),fontFamily: 'Poppins'),),
                                                  )
                                                ],
                                              ),

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
                                                        width: 3,
                                                      ),
                                                      // Center(child: Text(leaverequest.noOfDays.toString() + '  Days',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400,color: Color(0xFF98A2B3),fontFamily: 'Poppins'),)),
                                                      Center(child: Text('1  Days',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400,color: Color(0xFF98A2B3),fontFamily: 'Poppins'),)),
                                                    ],
                                                  ),


                                                  // Text('${formatDate(leaverequest.startDate.toString())} - ${formatDate(leaverequest.endDate.toString())}',style: TextStyle(color: Color(0xFF98A2B3),fontSize: 12,fontFamily: 'Poppins'),)
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top:10.0,left: 20),
                                              child: Row(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Center(child: Image.asset('assets/images/calendar2.png',height: 20,width: 20,color: Color(0xFF98A2B3),)),
                                                      SizedBox(
                                                        width: 3,
                                                      ),
                                                      Center(child: Text('21 January, 2024 - 22 January, 2024',style: TextStyle(color: Color(0xFF98A2B3),fontSize: 14,fontFamily: 'Poppins'),))
                                                      // Center(child: Text('${formatDate(leaverequest.startDate.toString())} - ${formatDate(leaverequest.endDate.toString())}',style: TextStyle(color: Color(0xFF98A2B3),fontSize: 12,fontFamily: 'Poppins'),))
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

  Widget buildScrollablesheet() {
    print("skjdbf");
    return DraggableScrollableSheet(builder: (context,scrollController){
      return Container(
        color: Colors.black12,
      );

    });
  }
  Widget _buildBottomSheetContent() {
    return FractionallySizedBox(
      heightFactor: 4,
      child:
      Container(
        //height: 1000, // Adjust height as needed
        padding: EdgeInsets.all(16),
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
              padding: const EdgeInsets.only(top: 20.0),
              child: Center(child: Image.asset('assets/images/profile.png', width: 50, height: 50)),
            ),
            Column(
              children: [
                Center(child: Text('Leo Rhiel Maddsen',style: TextStyle(fontSize:16,fontFamily: 'Poppins',fontWeight: FontWeight.w500,color: Color(0xFF1D2939) ),)),
                Center(child: Text('Ux Designer',style: TextStyle(fontSize:12,fontFamily: 'Poppins',fontWeight: FontWeight.w400,color: Color(0xFF98A2B3) ),)),

              ],
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                'This is a sample bottom sheet content. Add your desired UI here.',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Add functionality here
              },
              child: Text('Action Button'),
            ),
          ],
        ),
      ),
    );
  }
}


import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:sampleaura/controller/holiday.dart';
class SelfHoliday extends StatefulWidget {
  const SelfHoliday({super.key});

  @override
  _SelfHolidayState createState() => _SelfHolidayState();
}

class _SelfHolidayState extends StateMVC<SelfHoliday> {
  HolidayController? _con = null;

 _SelfHolidayState() : super(HolidayController()){
   _con = controller as HolidayController;

 }
  String formatDate(String date) {
    final parsedDate = DateTime.parse(date); // Parse the ISO 8601 string
    final formattedDate = DateFormat('dd MMMM, yyyy')
        .format(parsedDate); // Format to desired output
    return formattedDate;
  }
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _con?.fetchholiday();
    });
 // setState(() {
 //   _con?.fetchholiday().then((_){
 //     print(_con?.holidaylist.length);
 //
 //   });
 // });
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(title: Text('Holidays',style: TextStyle(fontFamily: 'Poppins',fontSize: 20,fontWeight:FontWeight.w500),),
        leading: Icon(Icons.arrow_back_ios),),
        body: DefaultTabController(length: 3, child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ButtonsTabBar(
                        radius: 12,
                        labelSpacing:20,
                        backgroundColor: const Color(0xFFE0EDFF),
                        unselectedBackgroundColor: Colors.transparent,
                        contentPadding: EdgeInsets.symmetric(horizontal: 32),
                        unselectedLabelStyle: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: Color(0xFF98A2B3)
                        ),
                        labelStyle: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: Color(0xFF030303)
                        ),


                        tabs: [
                          Tab(text: 'All',),
                          Tab(text: 'Mandatory',),
                          Tab(text: 'Optional',),


                        ]),
                  ),
                  Expanded(child: TabBarView(children: [

                   ListView.builder(
                     itemCount:_con?.holidaylist.length,
                     itemBuilder: (BuildContext context, int index) {
                       var holiday = _con?.holidaylist[index];

                       return  Stack(
                         children: [
                           Positioned(
                             top:32,
                             right: -5,
                             child: Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: Container(
                                 height: 90,
                                 width: 90,
                                 child: Image.asset('assets/images/holiday.png'),
                               ),
                             ),
                           ),
                           Column(
                             children: [
                               Padding(
                                 padding: const EdgeInsets.only(left: 10.0,right: 10,top: 10),
                                 child: Container(height: 126,width: 361,
                                   decoration: BoxDecoration(
                                       border: Border.all(
                                         color: Color(0XFFE4E7EC),
                                       ),
                                       borderRadius: BorderRadius.circular(8)
                                   ),
                                   child: Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       Padding(
                                         padding: const EdgeInsets.only(top:15.0,left: 16,right: 10),
                                         child: Row(
                                           children: [
                                             Text(holiday!.name,style: TextStyle(fontSize:14,fontFamily: 'Poppins',fontWeight: FontWeight.w500),),
                                             Spacer(),
                                             holiday.mandatory == true ? Text('Mandatory',style: TextStyle(fontSize: 14,fontFamily: 'Poppins',color: Color(0xFF004AAD)),):Text('Optional',style: TextStyle(fontSize: 14,fontFamily: 'Poppins',color: Color(0xFF004AAD)))
                                           ],
                                         ),
                                       ),
                                       Padding(
                                         padding: const EdgeInsets.only(top: 20.0,left: 16),
                                         child: Column(
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: [
                                             Row(
                                               mainAxisAlignment: MainAxisAlignment.start,
                                               children: [
                                                 Image.asset('assets/images/calendar1.png',height: 17.42,width: 16.5,),
                                                 SizedBox(width: 5,),
                                                 Text('2 Days',style:TextStyle(fontFamily: 'Poppins',fontSize:12,fontWeight: FontWeight.w400 ),)
                                               ],
                                             ),
                                             SizedBox(
                                               height: 15,
                                             ),
                                             Row(
                                               mainAxisAlignment: MainAxisAlignment.start,
                                               children: [
                                                 Image.asset('assets/images/calendar2.png',height: 17.42,width: 16.5,),
                                                 SizedBox(width: 5,),
                                                 Text(DateFormat('d MMM yyyy').format(holiday.fromDate) + ' - ' + DateFormat('d MMM yyyy').format(holiday.toDate),style:TextStyle(fontFamily: 'Poppins',fontSize:12,fontWeight: FontWeight.w400 ),)
                                               ],
                                             )
                                           ],
                                         ),
                                       )
                                     ],
                                   ),
                                 ),
                               )
                             ],
                           )
                         ],
                       );
                     },

                   ),
                      ListView.builder(
                        itemCount:_con?.holidaylist.length,
                        itemBuilder: (BuildContext context, int index) {
                          var holiday = _con?.holidaylist[index];

                          return holiday?.mandatory == true ?
                          SingleChildScrollView(
                            child: Stack(
                              children: [
                                Positioned(
                                  top:32,
                                  right: -5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 90,
                                      width: 90,
                                      child: Image.asset('assets/images/holiday.png'),
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10.0,right: 10,top: 10),
                                      child: Container(height: 126,width: 361,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Color(0XFFE4E7EC),
                                            ),
                                            borderRadius: BorderRadius.circular(8)
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top:15.0,left: 16,right: 10),
                                              child: Row(
                                                children: [
                                                  Text(holiday!.name,style: TextStyle(fontSize:14,fontFamily: 'Poppins',fontWeight: FontWeight.w500),),
                                                  Spacer(),
                                                  holiday.mandatory == true ? Text('Mandatory',style: TextStyle(fontSize: 14,fontFamily: 'Poppins',color: Color(0xFF004AAD)),):Text('Optional',style: TextStyle(fontSize: 14,fontFamily: 'Poppins',color: Color(0xFF004AAD)))
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 20.0,left: 16),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Image.asset('assets/images/calendar1.png',height: 17.42,width: 16.5,),
                                                      SizedBox(width: 5,),
                                                      Text('2 Days',style:TextStyle(fontFamily: 'Poppins',fontSize:12,fontWeight: FontWeight.w400 ),)
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Image.asset('assets/images/calendar2.png',height: 17.42,width: 16.5,),
                                                      SizedBox(width: 5,),
                                                      Text(DateFormat('d MMM yyyy').format(holiday.fromDate) + ' - ' + DateFormat('d MMM yyyy').format(holiday.toDate),style:TextStyle(fontFamily: 'Poppins',fontSize:12,fontWeight: FontWeight.w400 ),)
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ): Container();
                        },

                      ),
                    ListView.builder(
                      itemCount:_con?.holidaylist.length,
                      itemBuilder: (BuildContext context, int index) {
                        var holiday = _con?.holidaylist[index];

                        return holiday?.mandatory != true ?
                        SingleChildScrollView(
                          child: Stack(
                            children: [
                              Positioned(
                                top:32,
                                right: -5,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 90,
                                    width: 90,
                                    child: Image.asset('assets/images/holiday.png'),
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0,right: 10,top: 10),
                                    child: Container(height: 126,width: 361,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Color(0XFFE4E7EC),
                                          ),
                                          borderRadius: BorderRadius.circular(8)
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top:15.0,left: 16,right: 10),
                                            child: Row(
                                              children: [
                                                Text(holiday!.name,style: TextStyle(fontSize:14,fontFamily: 'Poppins',fontWeight: FontWeight.w500),),
                                                Spacer(),
                                                holiday.mandatory == true ? Text('Mandatory',style: TextStyle(fontSize: 14,fontFamily: 'Poppins',color: Color(0xFF004AAD)),):Text('Optional',style: TextStyle(fontSize: 14,fontFamily: 'Poppins',color: Color(0xFF004AAD)))
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 20.0,left: 16),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Image.asset('assets/images/calendar1.png',height: 17.42,width: 16.5,),
                                                    SizedBox(width: 5,),
                                                    Text('2 Days',style:TextStyle(fontFamily: 'Poppins',fontSize:12,fontWeight: FontWeight.w400 ),)
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Image.asset('assets/images/calendar2.png',height: 17.42,width: 16.5,),
                                                    SizedBox(width: 5,),
                                                    Text(DateFormat('d MMM yyyy').format(holiday.fromDate) + ' - ' + DateFormat('d MMM yyyy').format(holiday.toDate),style:TextStyle(fontFamily: 'Poppins',fontSize:12,fontWeight: FontWeight.w400 ),)
                                                  ],
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ): Container();
                      },

                    ),
                  ]))
                ],
              )

            ),

          ],
        )),
      ),
    );
  }
}

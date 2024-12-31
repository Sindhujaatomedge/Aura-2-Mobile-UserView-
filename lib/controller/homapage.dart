import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:sampleaura/model/response/checkintime.dart';
import 'package:sampleaura/model/response/leavetypeself.dart';
import 'package:sampleaura/model/response/upcomingbirthday.dart';
import 'package:sampleaura/model/response/upcomingholiday.dart';
import 'package:sampleaura/repo/homepage_repository.dart' as repo;

class HomePageController extends ControllerMVC {
  AttendanceCheckin? attendanceCheckin;
  List<UpcomingHoliday> upcomingholiday =[];
  List<UpcomingBirthday> upcomingbirthday =[];
  List<LeaveData> leavetypedata =[];

  HomePageController(){

  }

  Future<void> fetchcheckin() async {

    attendanceCheckin = await repo.fetchcheckin();
    print('controller');
    print(attendanceCheckin?.isCheckoutPending);
  }

  Future<void> fetchUpcominghoilday() async {

    List<UpcomingHoliday>? hoildaydata =  await repo.fetchupcomingholiday();
    print(hoildaydata);

    upcomingholiday =hoildaydata!;


  }
  Future<void> fetchUpcomingBirthday() async {

    List<UpcomingBirthday>? bithdaydata =  await repo.fetchupcomingbirthday();

    print(bithdaydata);
    setState((){
      upcomingbirthday =bithdaydata!;
    });



  }
  Future<List<LeaveData>?> fetchleavetype() async {

    List<LeaveData>? leavedata =  await repo.fetchleavetype();

   // print(leavedata?.length);
    leavetypedata = leavedata!;
    print(leavedata.length);
    setState((){
      leavetypedata = leavedata!;
      print(leavedata.length);
    });
    return leavedata;



  }


}
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:sampleaura/model/response/checkintime.dart';
import 'package:sampleaura/model/response/employeepermission.dart';
import 'package:sampleaura/model/response/leavetypeself.dart';
import 'package:sampleaura/model/response/upcomingbirthday.dart';
import 'package:sampleaura/model/response/upcomingholiday.dart';
import 'package:sampleaura/repo/homepage_repository.dart' as repo;

class HomePageController extends ControllerMVC {
  AttendanceCheckin? attendanceCheckin;
  List<UpcomingHoliday> upcomingholiday =[];
  List<UpcomingBirthday> upcomingbirthday =[];
  List<LeaveData> leavetypedata =[];
  RolePermission? permission;
  bool? create = true;
  bool? edit = true;
  bool? delete = true;

  HomePageController(){

  }

  Future<void> fetchcheckin() async {
    attendanceCheckin = await repo.fetchcheckin();
  }

  Future<void> fetchUpcominghoilday() async {
    List<UpcomingHoliday>? hoildaydata =  await repo.fetchupcomingholiday();
    upcomingholiday =hoildaydata!;
  }

  Future<void> fetchrolepermission() async{
    permission =await repo.fetchpermission();
    permission!.permission!.self!.contains(5) || permission!.permission!.self!.contains(1)?permission?.permission?.self:permission?.permission?.self?.add(1) ;
    create = permission!.permission!.self!.contains(2) ||permission!.permission!.self!.contains(5) ;
    edit = permission!.permission!.self!.contains(3) || permission!.permission!.self!.contains(5);
    delete = permission!.permission!.self!.contains(4) || permission!.permission!.self!.contains(5);
  }
  Future<void> fetchUpcomingBirthday() async {
    List<UpcomingBirthday>? bithdaydata =  await repo.fetchupcomingbirthday();
    upcomingbirthday =bithdaydata!;
    setState((){
      upcomingbirthday =bithdaydata!;
    });
  }
  Future<List<LeaveData>?> fetchleavetype() async {
    List<LeaveData>? leavedata =  await repo.fetchleavetype();
    leavetypedata = leavedata!;
    setState((){
      leavetypedata = leavedata!;
    });
    return leavedata;
  }
}
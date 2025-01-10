import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:sampleaura/model/response/empleavingthismonth.dart';
import 'package:sampleaura/model/response/employeeturnover.dart';
import 'package:sampleaura/model/response/manageagedistribution.dart';
import 'package:sampleaura/model/response/manageattendancedata.dart';
import 'package:sampleaura/model/response/manageheadcount.dart';
import 'package:sampleaura/model/response/manageleavereport.dart';
import 'package:sampleaura/model/response/managesatisfaction.dart';
import 'package:sampleaura/model/response/managetenure.dart';
import 'package:sampleaura/repo/manage_repository.dart' as repo;

import '../model/response/feedbackcount.dart';
import '../model/response/managepresentcount.dart';

class ManageHomeController extends ControllerMVC {
  List<AttendanceData> attendanceData = [];
  List<AgeDistribution> ageDistributionData = [];
  List<LeaveReport> leavereportData = [];
  List<EmployeeTenure> employeeTenureData = [];
  List<HeadCount> employeeheadcount = [];
  List<EmployeeSatisfaction> employeeSatisfactionData = [];
  bool isLoading = true;
  var attendancecount;
  var attendancepercentage;
Presenttodaycount? presenttodaycount;
Empleavingthismonth? employeleavethismonth;
  FeedBacktotal? feedbacktotal;
  EmployeeTurnover? turnover;


  ManageHomeController();

  Future<List<AttendanceData>?> fetchAttendanceData() async {
    try {
      print('Fetching attendance data...');
      List<AttendanceData>? data = await repo.fetchattandancedata();
      if (data != null) {
       setState((){
         attendanceData = data;
       }) ;
        isLoading = false;
        print('Fetched ${attendanceData.length} attendance records.');
        return attendanceData;

      } else {
        print('No attendance data found.');
        return [];
      }
    } catch (error) {
      print('Error fetching attendance data: $error');
      return null;
    }
  }
  Future<List<AgeDistribution>?> fetchAgeDistributionData() async {
    try {
      print('Fetching attendance data...');
      List<AgeDistribution>? data = await repo.fetchageDistributiondata();
      if (data != null) {
        setState((){
         ageDistributionData = data;
        }) ;
        isLoading = false;
        print('Fetched ${ageDistributionData.length} attendance records.');
        return ageDistributionData;

      } else {
        print('No attendance data found.');
        return [];
      }
    } catch (error) {
      print('Error fetching attendance data: $error');
      return null;
    }
  }
  Future<List<LeaveReport>?> fetchLeaveReportData() async {
    try {
      print('Fetching leavereport data...');
      List<LeaveReport>? data = await repo.fetchLeaveReportdata();
      if (data != null) {
        setState((){
         leavereportData = data;
        }) ;
        isLoading = false;
        print('Fetched ${leavereportData.length} LeaveReport records.');
        return leavereportData;

      } else {
        print('No Leave data found.');
        return [];
      }
    } catch (error) {
      print('Error fetching leave data: $error');
      return null;
    }
  }
  Future<List<EmployeeTenure>?> fetchEmployeeTenureData() async {
    try {
      print('FetchingTenure data...');
      List<EmployeeTenure>? data = await repo.fetchEmployeeTenuredata();
      if (data != null) {
        setState((){
         employeeTenureData = data;
        }) ;
        isLoading = false;
        print('Fetched ${leavereportData.length} Employeetenure records.');
        return employeeTenureData;

      } else {
        print('No employeetenure data found.');
        return [];
      }
    } catch (error) {
      print('Error fetching employeetenure data: $error');
      return null;
    }
  }
  Future<List<EmployeeSatisfaction>?> fetchSatisfactionData() async {
    try {
      print('Fetching Satisfaction data...');
      List<EmployeeSatisfaction>? data = await repo.fetchEmployeeSatisfactiondata();
      if (data != null) {
        setState((){
         employeeSatisfactionData = data;
        }) ;
        isLoading = false;
        print('Fetched ${employeeSatisfactionData.length} satisfaction records.');
        return employeeSatisfactionData;

      } else {
        print('No satisfaction data found.');
        return [];
      }
    } catch (error) {
      print('Error fetching satisfaction data: $error');
      return null;
    }
  }
  Future<List<HeadCount>?> fetchHeadCountData() async {
    try {
      print('Fetching HeadCountData data...');
      List<HeadCount>? data = await repo.fetchEmployeeHeadCountdata();
      if (data != null) {
        setState((){
         employeeheadcount = data;
        }) ;
        isLoading = false;
        print('Fetched ${employeeheadcount.length} HeadCount records.');
        return employeeheadcount;

      } else {
        print('No HeadCount  data found.');
        return [];
      }
    } catch (error) {
      print('Error fetching HeadCount  data: $error');
      return null;
    }
  }
  Future<Object?> fetchPresenttodaycount() async {
    try {
      print('Fetching Presenttodaycount data...');
      Presenttodaycount? data = await repo.fetchEmployeePresenttodaycount();
      if (data != null) {
        setState((){
          presenttodaycount = data as Presenttodaycount?;
        }) ;
        isLoading = false;
        attendancepercentage = presenttodaycount?.percentage;
        attendancecount = presenttodaycount?.totalpresentcount;
        print('Fetched ${presenttodaycount?.percentage}  records.');
        print('Fetched ${presenttodaycount?.totalpresentcount}  records.');
        return presenttodaycount;

      } else {
        print('presenttodaycount  data found.');
        return [];
      }
    } catch (error) {
      print('Error fetching presenttodaycount  data: $error');
      return null;
    }
  }
  Future<Object?> fetchEmployeeLeavingCount() async {
    try {
      print('Fetching EmployeeLeavingCount data...');
      Empleavingthismonth? data = await repo.fetchEmployeeleavingthismonthcount();
      if (data != null) {
        setState((){
          employeleavethismonth = data as Empleavingthismonth?;
        }) ;
        isLoading = false;

        print('Fetched ${employeleavethismonth?.percentage} Employee Leaving records.');
        print('Fetched ${employeleavethismonth?.count} Employee Leaving records.');
        return employeleavethismonth;

      } else {
        print('employee data found.');
        return [];
      }
    } catch (error) {
      print('Error fetching employee  data: $error');
      return null;
    }
  }
  Future<Object?> fetchFeedBacktotal() async {
    try {
      print('Fetching EmployeeLeavingCount data...');
      FeedBacktotal? data = await repo.fetchEmployeefeedbackcount();
      if (data != null) {
        setState((){
          feedbacktotal = data as  FeedBacktotal?;
        }) ;
        isLoading = false;

        print('Fetched ${feedbacktotal?.totalfeedbackpercentage} Employee Feedback records.');
        print('Fetched ${feedbacktotal?.totalfeedbackcount} Employee Feedback records.');
        return FeedBacktotal;

      } else {
        print('employee data found.');
        return [];
      }
    } catch (error) {
      print('Error fetching employee  data: $error');
      return null;
    }
  }
  Future<Object?> fetchEmployeeTurnover() async {
    try {
      print('Fetching EmployeeTurnover data...');
      EmployeeTurnover? data = await repo.fetchEmployeeTurnover();
      if (data != null) {
        setState((){
          turnover = data as EmployeeTurnover ?;
        }) ;
        isLoading = false;

        print('Fetched ${turnover?.totalempleavingthisyear} Employee Feedback records.');
        print('Fetched ${turnover?.percentage} Employee Feedback records.');
        return FeedBacktotal;

      } else {
        print('employee data found.');
        return [];
      }
    } catch (error) {
      print('Error fetching employee  data: $error');
      return null;
    }
  }
}
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:sampleaura/model/response/manageagedistribution.dart';
import 'package:sampleaura/model/response/manageattendancedata.dart';
import 'package:sampleaura/model/response/manageleavereport.dart';
import 'package:sampleaura/model/response/managesatisfaction.dart';
import 'package:sampleaura/model/response/managetenure.dart';
import 'package:sampleaura/repo/manage_repository.dart' as repo;

class ManageHomeController extends ControllerMVC {
  List<AttendanceData> attendanceData = [];
  List<AgeDistribution> ageDistributionData = [];
  List<LeaveReport> leavereportData = [];
  List<EmployeeTenure> employeeTenureData = [];
  List<EmployeeSatisfaction> employeeSatisfactionData = [];
  bool isLoading = true;

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
}
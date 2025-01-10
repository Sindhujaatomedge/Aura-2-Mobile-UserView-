import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:sampleaura/model/request/regularize.dart';
import 'package:sampleaura/model/response/attendancebyorgid.dart';
import 'package:sampleaura/model/response/checkincheckout.dart';
import 'package:sampleaura/repo/attendance_repository.dart'as repository;

import '../model/dropdown/member.dart';
import '../model/response/attendancerequetlog.dart';

class AttendanceController extends ControllerMVC {
  List<Attendancelog> attendancelist = [];
  List<Attendancelog> requestattendancelist = [];
  List<AttendanceRequestLog> requestattendancelistlog = [];
  List<MemberDropdown>fetchmemberdatavlaue =[];
  List<Checkincheheckoutmedium> filteredAttendancelist =[];


  bool isLoading = true;
  AttendanceController (){

  }
  Future<void> fetchResponse() async {
    print("Fetching data...");
    isLoading = true; // Start loading state
    Timer(Duration(minutes: 2), () {
      if (isLoading) {
        setState(() {
          isLoading = false; // Stop shimmer effect after 2 minutes
        });
      }
    });

    try {
      // Fetch data from the repository
      List<Attendancelog>? value = await repository.fetchResponseData();
      print('Fetched value');
      print(value?.length ?? 0);

      // Update the attendance list
      attendancelist = value ?? [];
      print('Attendance list updated: ${attendancelist.length}');

      // Filter and map to Checkinchecheckoutmedium objects
      filteredAttendancelist = attendancelist
          .where((log) =>
      log.checkinmedium == "web" && log.checkouttime.isEmpty) // Filtering condition
          .map((log) => Checkincheheckoutmedium(
        checkinmedium: log.checkinmedium,
        checkintime: log.checkintime,
        checkouttime: log.checkouttime,
      ))
          .toList();

      print('Filtered Attendance List Length: ${filteredAttendancelist.length}');
    } catch (e) {
      print('Error fetching data: $e');
      attendancelist = []; // Clear the list on error
      filteredAttendancelist = []; // Clear filtered list on error
    }
    // finally {
    //   // Ensure loading stops when data is fetched or after the shimmer timeout
    //   if (mounted) {
    //     setState(() {
    //       isLoading = false;
    //     });
    //   }
    // }
  }






  Future<void> fetchResponseattendancerequest()async {
    print("Data");
    setState((){
      isLoading = false;
    });
    repository.fetchResponseRequestData().then((value){
      print(value?.length);
      List<AttendanceRequestLog>? requestattendancedata = value;
      requestattendancelistlog= requestattendancedata!;

      setState((){
        List<AttendanceRequestLog>? requestattendancedata = value;
        requestattendancelistlog= requestattendancedata!;
      });
      setState((){
        repository.fetchResponseData();

      });
    });

  }
  Future<void> viewmembervalue() async {
    print("Data value");
    try {
      isLoading = true;
      fetchmemberdatavlaue = (await repository.fetchResponseMemberDatadropdown()) ?? [];
      print('Fetched Member in controller: $fetchmemberdatavlaue');
    } catch (e) {
      print('Error in Member: $e');
    } finally {
      isLoading = false;
    }
  }
  Future<void> applymanual(Regularize regularizeModel,BuildContext contex) async {
    setState((){
      isLoading = false;

    });
    repository.postData(regularizeModel,contex).then((value){
      print(value);

    });


  }
  Future<void> editapplymanual(Regularize regularizeModel,BuildContext context,String id) async {
    setState((){
      isLoading = false;

    });
    repository.editData(regularizeModel,context,id).then((value){
      print(value);

    });


  }
  Future<void> deletemanualcheckin(BuildContext context,String id,String userid) async {
    setState((){
      isLoading = false;

    });
    repository.deleteData(context,id,userid).then((value){
      print(value);

    });


  }

  Future <void> approve(String id, AttendanceRequestLog attendancerequest)async {
    setState((){
      isLoading = false;

    });
    repository.approve(id,attendancerequest).then((value){

      setState((){
       repository.fetchResponseRequestData();
      });

    });



  }





}
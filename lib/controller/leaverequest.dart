import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:sampleaura/model/dropdown/leavetype.dart';
import 'package:sampleaura/model/dropdown/member.dart';
import 'package:sampleaura/model/request/leaverequest.dart';
import 'package:sampleaura/model/response/leaverequestbtuserid.dart';
import 'package:sampleaura/model/response/leaverequestbyorgid.dart';
import 'package:sampleaura/repo/leaverequest_repository.dart' as repository;
import 'package:sampleaura/screen/attendanceself.dart';

import '../model/response/leavebalance.dart';
import '../repo/leaverequest_repository.dart';
import '../screen/leaverequestself.dart';


class LeaveRequestController extends ControllerMVC{
  List<LeaveModel> leaverequest = [];
  List<LeaveRequestByuserId> leaveuserdata = [];
  bool isLoading = true;
  String errorMessage ='';
  List<LeaveTypeDropdownValue>fetchroledatavlaue =[];
  List<MemberDropdown>fetchmemberdatavlaue =[];
  LeaveDetails? leavebalance;
  var balance = '';

  LeaveRequestController(){

  }

  Future<void> fetchResponseleave() async {
    print("Fetching leave data...");
    setState(() {
      isLoading = true; // Set loading to true while fetching data
    });

    try {
      List<LeaveModel>? leavedata = await repository.fetchResponseData();
      if (leavedata != null && leavedata.isNotEmpty) {
        print("Data fetched: ${leavedata.length}");
        setState(() {
          leaverequest = leavedata;
          isLoading = false;
        });
      } else {
        print("No leave requests found.");
        setState(() {
          leaverequest = [];
          isLoading = false;
        });
      }
    } catch (error) {
      print("Error fetching leave data: $error");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future <void> approve(String id, LeaveModel leavemodel)async {
    setState((){
      isLoading = false;

    });
    repository.approve(id,leavemodel).then((value){

      setState((){
        repository.fetchResponseData();
      });

    });



  }
  Future <void> reject(String id, LeaveModel leavemodel)async {
    setState((){
      isLoading = false;

    });
    repository.reject(id,leavemodel).then((value){

      setState((){
        repository.fetchResponseData();
      });

    });



  }



  Future<void> fetchresponseuserleave()async {
    print('UserVAlue');
    setState((){
      isLoading =false;

    });
    repository.fetchResponseUserData().then((value){
      print(value?.length);
      List<LeaveRequestByuserId>? leaveuserdatavalue = value;
      leaveuserdata = leaveuserdatavalue!;

      setState((){

        print(leaveuserdata.length);

      });

    });


  }

  Future<void> viewLeaveTypevalue() async {
    print("Data value");
    try {
      isLoading = true;
      fetchroledatavlaue = (await repository.fetchResponseDatadropdown()) ?? [];
      print('Fetched LeaveType in controller: $fetchroledatavlaue');
    } catch (e) {
      print('Error in LeaveType: $e');
    } finally {
      isLoading = false;
    }
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

  Future<void> applyLeaveRequest(LeaveRequestModel leaveRequestModel,BuildContext context) async {
    repository.postdata(leaveRequestModel,context).then((value){
      setState((){
        fetchresponseuserleave();
      });

    });

   // var response = await postdata(leaveRequestModel);
    // try {
    //   var jsonResponse = jsonDecode(response);
    //
    //   if (jsonResponse is Map<String, dynamic>) {
    //
    //     String? message = jsonResponse.values.firstWhere((value) => value is String,);
    //     print("Message: $message");
    //     Fluttertoast.showToast(
    //       msg: message.toString(),
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.BOTTOM_RIGHT,
    //       backgroundColor: Colors.blueAccent,
    //       textColor: Colors.white,
    //     );
    //
    //
    //   }
    // } catch (e) {
    //   print("Failed to decode response: $e");
    //
    // }
  }
  Future<void> editLeaveRequest(LeaveRequestModel leaveRequestModel, String id,BuildContext context) async {
    repository.editdata(leaveRequestModel, id,context).then((value){
      setState((){
        fetchresponseuserleave();
      });
    });

  }
  Future<void> deleteLeaveRequest(String id,BuildContext context)async {
    repository.deletedata(id, context).then((value){
      setState((){
        fetchresponseuserleave();

      });

    });

  }

  Future<void> viewLeavebalance(String id) async {
    print("Data value");
    try {
      isLoading = true;
     repository.fetchleavedetails(id).then((value){
       print(value?.noOfDays);
       balance = value!.leaveBalance.toString();
       setState((){
         balance = value!.leaveBalance.toString();
       });

       print(balance);

     });
      print('Fetched LeaveType in controller: $fetchroledatavlaue');
    } catch (e) {
      print('Error in LeaveType: $e');
    } finally {
      isLoading = false;
    }
  }
}
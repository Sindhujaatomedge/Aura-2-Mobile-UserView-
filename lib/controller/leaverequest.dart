import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:sampleaura/model/response/leaverequestbyorgid.dart';
import 'package:sampleaura/repo/leaverequest_repository.dart' as repository;

class LeaveRequestController extends ControllerMVC{
  List<LeaveModel> leaverequest = [];
  bool isLoading = true;
  String errorMessage ='';

  LeaveRequestController(){

  }

  Future<void> fetchResponseleave()async {
    print("Data");
    setState((){
      isLoading = false;


    });
    repository.fetchResponseData().then((value){
      print(value?.length);

      setState((){
        List<LeaveModel>? leavedata = value;
        leaverequest = leavedata!;

      });




    });

  }

}
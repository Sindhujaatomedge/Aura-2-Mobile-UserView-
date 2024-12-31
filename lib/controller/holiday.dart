import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:sampleaura/model/response/holidaymodel.dart';
import 'package:sampleaura/repo/holiday_repository.dart' as repo;

class HolidayController extends ControllerMVC{
  List<HolidayModel> holidaylist = [];


  HolidayController(){

  }

  Future<void> fetchholiday()async {
    List<HolidayModel>? value = await repo.fetchHoliday();
    print(value?.length);
    setState((){
      holidaylist = value ?? [];
    });
   // holidaylist = value ?? [];




  }
}
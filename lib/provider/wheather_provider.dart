import 'dart:convert';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
import 'package:wheatherproject/top_levelobjects.dart';
enum ViewState { idle, busy }
class WheatherApiModel extends ChangeNotifier{
  Map<String, dynamic> WheatherData = {};
  String errorText="";
  var _state = ViewState.idle;

  ViewState get getState => _state;
  void setState(ViewState viewState) {
    _state = viewState;
    print("state is ${_state}");
    notifyListeners();
  }

  Future<void> getCurrentWheather(String city) async{
    String getData="https://api.openweathermap.org/data/2.5/weather?q=${city}&appid=5659845f098b7f2ca2bb7a7b739b6783";
   try{
     WheatherData={};
     setState(ViewState.busy);
     TopFunctions.internetConnectivityStatus().then((value) async {
       if(value == true){

         var response = await http.get(Uri.parse(getData));
         var pareseData=jsonDecode(response.body);
         if(response.statusCode == 200){
           WheatherData=pareseData;
           errorText="";
           Future.delayed(Duration(seconds: 3),(){
             setState(ViewState.idle);
           });
         }

         else{
           WheatherData={};
           setState(ViewState.idle);
           TopFunctions.showScaffold("${pareseData['message']}");
         }
       }
       else{
         TopFunctions.showScaffold("No Internet Connectivity");
       }
     });

   }

       catch(e){
         WheatherData={};
         setState(ViewState.idle);
         TopFunctions.showScaffold("${e}");

       }


  }
}



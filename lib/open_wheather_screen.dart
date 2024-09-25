import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wheatherproject/colors.dart';
import 'package:wheatherproject/network.dart';
import 'package:wheatherproject/provider/wheather_provider.dart';
import 'package:wheatherproject/top_levelobjects.dart';
class OpenWheatherScreen extends StatefulWidget {
  const OpenWheatherScreen({Key? key}) : super(key: key);

  @override
  State<OpenWheatherScreen> createState() => _OpenWheatherScreenState();
}


class _OpenWheatherScreenState extends State<OpenWheatherScreen> {
  Map<String,dynamic> details={};
  TextEditingController locationPick = new TextEditingController(text: "");
  Future<void> getCountry() async {
    Network n = new Network("http://ip-api.com/json");
    try {
      (await n.getData().then((value) {
        print("VALUES ${value}");
        details['city'] = jsonDecode(value)["city"];
        details['regionName'] = jsonDecode(value)["regionName"];
        details['timezone'] = jsonDecode(value)["timezone"];
        details['country'] = jsonDecode(value)["country"];
        details['lat'] = jsonDecode(value)["lat"];
        details['lon'] = jsonDecode(value)["lon"];

        print("getCountry ${details}");
      }));
      setState(() {});
    } catch (e) {
      print("Exception is ${e}");
      TopFunctions.showScaffold("No Internet Connectivity");
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: background,
      appBar: AppBar(title: Text("Open Wheather App",style: TextStyle(color: Colors.white),),
       backgroundColor:  solidColor,
      ),
      body: Consumer<WheatherApiModel>(
             builder: (context,data,child){
                 return    Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.stretch,
                     // mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Icon(Icons.cloud_outlined,color: Colors.white,size: 100,),
                       Text("Open Wheather App",
                         textAlign: TextAlign.center,
                         style: TextStyle(fontSize: 14,color: solidColor,fontWeight: FontWeight.w600),),
                       SizedBox(height: 10.0,),
                       TextFormField(
                         textAlignVertical: TextAlignVertical.top,
                         controller: locationPick,
                         // onChanged: (String value) {
                         //   locationPick.text=value;
                         //
                         // },

                         decoration: InputDecoration(
                           suffixIcon: IconButton(
                             onPressed: () {
                               data.getCurrentWheather(locationPick.text);
                             },
                             icon: Icon(
                               Icons.send,
                               color: background,
                             ),
                           ),
                           border: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(10.0,),
                               borderSide: BorderSide(color: solidColor)

                           ),
                           enabledBorder: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(10.0,),
                               borderSide: BorderSide(color: solidColor)

                           ),
                           fillColor: Colors.white,
                           filled: true,
                           label: Text("Enter City Name",style: TextStyle(color: solidColor,fontSize: 12),),

                         ),
                       ),
                       SizedBox(height: 10.0,),
                       Text("${data.errorText}",style: TextStyle(fontSize: 16,color: Colors.red),),
                       data.WheatherData.isNotEmpty ?
                       Card(
                         color: Colors.white,
                         elevation: 3,
                         child: Padding(
                           padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Row(
                                 children: [
                                   Icon(Icons.cloud_circle,color: Colors.blue,),
                                   SizedBox(width: 10.0,),
                                   Text("${data.WheatherData['weather'][0]['description']}",
                                     style:  TextStyle(fontSize: 14,color: solidColor,fontWeight: FontWeight.w600),),
                                 ],
                               ),
                               SizedBox(height: 10.0,),

                               // Row(
                               //   crossAxisAlignment: CrossAxisAlignment.center,
                               //
                               //   children: [
                               // Image.network("http://openweathermap.org/img/w/${data.WheatherData['weather'][0]['icon']+".png"}",fit: BoxFit.contain,),
                               //     SizedBox(width: 10.0,),
                               //     Text("Temperature  ${data.WheatherData['main']['temp']}",style: TextStyle(fontSize: 14,color: Color(0xff34495e),fontWeight: FontWeight.w600),),
                               //   ],
                               // ),
                               // SizedBox(height: 10.0,),

                               Row(
                                 children: [
                                  Icon(Icons.data_usage,color: Colors.blue,),
                                   SizedBox(width: 10.0,),

                                   Text("humidity ${data.WheatherData['main']['humidity']}",
                                     style: TextStyle(fontSize: 14,color: solidColor,fontWeight: FontWeight.w600),),
                                 ],
                               ),
                               SizedBox(height: 10.0,),
                               Row(
                                 children: [
                                   Icon(Icons.speed,color: Colors.blue,),
                                   SizedBox(width: 10.0,),
                                   Text("wind speed ${data.WheatherData['wind']['speed']}",
                                       style: TextStyle(fontSize: 14,color: solidColor,fontWeight: FontWeight.w600)),
                                 ],
                               ),
                               SizedBox(height: 10.0,),
                               Row(
                                 children: [
                                   Icon(Icons.timer,color: Colors.blue,),
                                   SizedBox(width: 10.0,),
                                   Text("Time ${DateFormat('hh:mm:ss').format(DateTime.fromMicrosecondsSinceEpoch(data.WheatherData['dt']),)}",
                                     style: TextStyle(fontSize: 14,color: solidColor,fontWeight: FontWeight.w600),),
                                 ],
                               ),
                               SizedBox(height: 10.0,),
                               Row(
                                 children: [
                                   Icon(Icons.location_city,color: Colors.blue,),
                                   SizedBox(width: 10.0,),
                                   Text("City Name ${data.WheatherData['name']}",
                                     style: TextStyle(fontSize: 14,color: solidColor,fontWeight: FontWeight.w600),),
                                 ],
                               ),


                             ],
                           ),
                         ),
                       )
                           :
                        SizedBox(),
                       SizedBox(height: 10.0,),

                       SizedBox(
                         height: 40,
                         child:
                         data.getState == ViewState.busy ?

                         Center(
                           child: CircularProgressIndicator(
                             color:solidColor,
                           ),
                         )
                             :


                         ElevatedButton(

                             style: ElevatedButton.styleFrom(
                                 backgroundColor: solidColor,
                                 shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(10.0)
                                 )
                             ),
                             onPressed: (){
                              getCountry().then((value) {
                                data.getCurrentWheather( details['city']);

                              });


                               // getCountry();

                             }, child: Text("Get Current Wheather",style: TextStyle(color: Colors.white,fontSize: 14),)),)
                     ],
                   ),
                 );


             },

      )
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: homepage(),
    );
  }
}

class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);

  @override
  _homepageState createState() => _homepageState();
}

class _homepageState extends State<homepage> {

  // final cityCotroller = TextEditingController();

  var cityname, maintemp,min,max,pressure,humidity,sunrise,sunset;

  Future getWeather() async {
    // final querypara = {'q': '','appid': ''};
    // String dk = "dhaka";
    // cityname != null ? cityname.toString() : "Coxs Bazar"

    final response = await http.get(Uri.parse("https://api.openweathermap.org/data/2.5/weather?q="+"dhaka"+"&units=metric&appid=ff626c524369045c7406b2f0c355630e"));

    var showData = convert.jsonDecode(response.body);

    setState(() {
      this.cityname = showData["name"];
      this.maintemp = showData["main"]["temp"];
      this.min = showData["main"]["temp_min"];
      this.max = showData["main"]["temp_max"];
      this.pressure = showData["main"]["pressure"];
      this.humidity = showData["main"]["humidity"];
      this.sunrise = showData["sys"]["sunrise"];
      this.sunset = showData["sys"]["sunset"];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    this.getWeather();
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Weather updates",style: TextStyle(fontFamily: "Azonix"),),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Column(
                children: [
                  // TextField(
                  //   controller: cityCotroller,
                  //   decoration: InputDecoration(
                  //     hintText: "City",
                  //   ),
                  // ),
                  // ElevatedButton(onPressed: (){
                  //   setState(() {
                  //     this.getWeather();
                  //   });
                  // }, child: Text("Search")),
                  Container(
                    // color: Colors.tealAccent,
                    decoration: BoxDecoration(
                        color: Colors.tealAccent,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 3.0), //(x,y)
                            blurRadius: 6.0,
                          ),
                        ]
                    ),
                    height: 260,
                    width: double.infinity,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(cityname != null ? cityname.toString() : "Coxs Bazar",style: TextStyle(fontFamily: "Azonix",color: Colors.indigo,fontSize: 30,fontStyle: FontStyle.italic),),
                            ],
                          ),
                          SizedBox(height: 8,),
                          Text(maintemp.toString()+"\u00B0"+"C",style: TextStyle(color: Colors.pink,fontSize: 25,fontWeight: FontWeight.bold),),
                          SizedBox(height: 25,),
                          // Text(DateFormat('h:mm:ss a').format(DateTime.now()),style: TextStyle(fontFamily: "Azonix",fontSize: 25,color: Colors.indigoAccent),),
                          StreamBuilder(
                            stream: Stream.periodic(Duration(seconds: 1)),
                              builder: (context, snapshot) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(DateFormat('h:mm').format(DateTime.now()),style: TextStyle(fontFamily: "Azonix",fontSize: 40,color: Colors.indigoAccent),),
                                    SizedBox(width: 5,),
                                    Container(width: 30,child: Center(child: Text(DateFormat('ss').format(DateTime.now()),style: TextStyle(fontFamily: "Azonix",fontSize: 15,color: Colors.indigoAccent),))),
                                    SizedBox(width: 10,),
                                    Text(DateFormat('a').format(DateTime.now()),style: TextStyle(fontFamily: "Azonix",fontSize: 30,color: Colors.indigoAccent),)
                                  ],
                                );
                              }
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15,),
              Container(color: Colors.greenAccent,child: ListTile(leading: FaIcon(FontAwesomeIcons.temperatureLow),title: Text("Minimum Temperature"),trailing: Text(min.toString()+" \u00B0"+"C"),)),
              SizedBox(height: 5,),
              Container(color: Colors.greenAccent,child: ListTile(leading: FaIcon(FontAwesomeIcons.temperatureHigh),title: Text("Maximum Temperature"),trailing: Text(max.toString()+" \u00B0"+"C"),)),
              SizedBox(height: 5,),
              Container(color: Colors.greenAccent,child: ListTile(leading: FaIcon(FontAwesomeIcons.snowflake),title: Text("Pressure"),trailing: Text(pressure.toString()+" hPa"),)),
              SizedBox(height: 5,),
              Container(color: Colors.greenAccent,child: ListTile(leading: FaIcon(FontAwesomeIcons.wind),title: Text("Humidity"),trailing: Text(humidity.toString()+" %"),)),
              SizedBox(height: 5,),
              Container(color: Colors.greenAccent,child: ListTile(leading: FaIcon(FontAwesomeIcons.cloudSun),title: Text("Sunrise"),trailing: Text(DateFormat('h:mm a').format(DateTime.fromMillisecondsSinceEpoch(sunrise*1000))),)),
              SizedBox(height: 5,),
              Container(color: Colors.greenAccent,child: ListTile(leading: FaIcon(FontAwesomeIcons.sun),title: Text("Sunset"),trailing: Text(DateFormat('h:mm a').format(DateTime.fromMillisecondsSinceEpoch(sunset*1000))),)),
              // +DateFormat('h:mm a').format(DateTime.fromMillisecondsSinceEpoch(sunset))
              SizedBox(height: 25,),
              ElevatedButton(onPressed: (){
                setState(() {
                  this.getWeather();
                });
              }, child: Text("Refresh")),
            ],
          ),
        )
    );
  }
}



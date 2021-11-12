import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // import icons for the weather app
import 'package:http/http.dart'
    as http; // gets information from the weather website
import 'dart:convert'; // built in import

// how we run the app
void main() => runApp(MaterialApp(
      title: "Weather App",
      home: Home(),
    ));

// create classes for different states
class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  var temp; // we use var because we aren't always sure what data we are going to be getting so this is the safest bet
  var description; // we are going to store these variables here and call them later in the code
  var currently; // these are dynamic variables
  var humidity;
  var windspeed;

  // this is what enables us to get data from the website
  // openweathermap.org is able to give us information about weather

  Future getWeather() async {
    http.Response response = await http.get(Uri.parse(
        "http://api.openweathermap.org/data/2.5/weather?q=Phoenix&units=imperial&appid=8fa297084176f2effe2408d4ce142d36"));
    var results = jsonDecode(response
        .body); // response.body goes through the body of the code and fills in the necessary information
    setState(() {
      this.temp = results['main'][
          'temp']; // these variables are based on the website data, we navigate through to get certain elements
      this.description = results['weather'][0]['description'];
      this.currently = results['weather'][0]['main'];
      this.humidity = results['main']['humidity'];
      this.windspeed = results['wind']['speed'];
    });
  }

  @override
  void initState() {
    super.initState();
    this.getWeather();
  }

  // this is the UI elements of our app
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        // the columns
        children: <Widget>[
          // widgets and containers
          Container(
            // gets the width and height of device
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width,
            color: Colors.indigo, // make the color indigo
            child: Column(
              // center everything on the page
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // add some padding to make everything look a little better
                Padding(
                  padding:
                      EdgeInsets.only(bottom: 10.0), // padding to the bottom
                  child: Text(
                    "Currently in Phoenix",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Text(
                  // this is basically saying:
                  // if the temp is not equal to null then take temp.tostring and
                  // concatenate it with the degree symbol. If it is null
                  // print "loading"
                  temp != null ? temp.toString() + "\u00B0" : "Loading",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40.0,
                      fontWeight: FontWeight.w600),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0), // padding to the top
                  child: Text(
                    currently != null ? currently.toString() : "Loading",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons
                        .thermometerHalf), // the fontAwesomeIcons have a lot built in icons that we can use.
                    title: Text("Temperature"),
                    trailing: Text(
                        temp != null ? temp.toString() + "\u00B0" : "Loading"),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.cloud),
                    title: Text("Weather"),
                    trailing: Text(description != null
                        ? description.toString()
                        : "Loading"),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.sun),
                    title: Text("Humidity"),
                    trailing: Text(
                        humidity != null ? humidity.toString() : "Loading"),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.wind),
                    title: Text("Wind Speed"),
                    trailing: Text(
                        windspeed != null ? windspeed.toString() : "Loading"),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

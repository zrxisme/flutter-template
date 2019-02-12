import 'dart:convert';
import "dart:io";
import "package:flutter/material.dart";
import "./layoutcon/layout.dart";
void main(){
  runApp(new MyApp());
}
class MyApp extends StatelessWidget{
    @override 
    Widget build(BuildContext context){
           return new MaterialApp(
             home: MyAppPage(),
             routes: <String,WidgetBuilder>{
               '/layout':(BuildContext context)=>MyLayoutApp()
             },
           );
    }
}


class MyAppPage extends StatefulWidget{
  MyAppPage({Key key}):super(key:key);
  @override
  _MyAppPageState createState()=>new _MyAppPageState();
}


class _MyAppPageState extends State<MyAppPage>{
   var _ipAddress = 'Unknown';
   var spacer = new SizedBox(height: 32.0);
   _getIPAddress() async {
    var url = 'https://httpbin.org/ip';
    var httpClient = new HttpClient();
    String result;
    try {
       var request = await httpClient.getUrl(Uri.parse(url));
       var response = await request.close();
       if(response.statusCode==HttpStatus.OK){
           var jsonObj = await response.transform(utf8.decoder).join();
           var data = json.decode(jsonObj);
           result = data['origin'];
       }else{
      result = 'Error getting IP address:\nHttp status ${response.statusCode}';
       }
    }catch(exception){
      result = "fail to get IP address";
    }
    if(!mounted) return;
    setState((){
      _ipAddress = result;
    });
}

void toLayout(){
  Navigator.pushNamed(context, "/layout");
}
   @override
   Widget build(BuildContext context){
      return new Scaffold(
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text('Your current IP address is:'),
              new Text('$_ipAddress'),
              spacer,
              new RaisedButton(
                onPressed: _getIPAddress,
                child: new Text("Get IP address"),
              ),
              new IconButton(
                icon: new Icon(Icons.label),
                onPressed: toLayout,
              )
            ],
          ),
        ),
      );
   }
}
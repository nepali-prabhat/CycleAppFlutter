import 'package:cycle_app/Home/home.dart';
import 'package:cycle_app/Home/pages/newLogin.dart';
import 'package:cycle_app/Service/locationService.dart';
import 'package:cycle_app/Service/userService.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';


GetIt getIt = new GetIt();

void main() {
    getIt.registerSingleton(UserService());
    getIt.registerSingleton(LocationService());
    runApp(MaterialApp(
        title: "The Cycle App", home: MyApp()
    ));
}

class MyApp extends StatelessWidget{
  final UserService userService = getIt.get<UserService>();
  @override
  Widget build(BuildContext context) {
    
    return StreamBuilder(
            stream: userService.isLoggedIn$,
            builder:(context, snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                    return Scaffold(body: Center(child: Text('loading screen here.')));
                }
                if(snapshot.connectionState == ConnectionState.active){
                    bool loggedIn = snapshot.data;
                    if(loggedIn){
                        return MyHome();
                    }else{
                        return NewLogin();
                    }
                }
        }
    );
  }
  
}
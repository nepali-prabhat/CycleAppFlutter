import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:cycle_app/Model/UserModel.dart';
import 'package:cycle_app/globals.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  BehaviorSubject<bool> isLoggedIn;
  BehaviorSubject<UserModel> user;
  BehaviorSubject<String> token;

  UserService() {

    isLoggedIn = new BehaviorSubject<bool>.seeded(false);
    user = new BehaviorSubject<UserModel>();
    token = new BehaviorSubject<String>();
    _readUserFromLocalStore();

  }
  //observable and current value of the subjects
  Observable<bool> get isLoggedIn$ => isLoggedIn.stream;
  bool get isLoggedInValue => isLoggedIn.value;

  Observable<UserModel> get user$ => user.stream;
  UserModel get userValue => user.value;

  Observable<String> get token$ => token.stream;
  String get tokenValue => token.value;


  Future<Map<String, dynamic>> authenticate({ String username,  String password}) async {
    final String loginURL = base_url + "/login";
    
    var client = new http.Client();

    try {
      var response = await client.post(
        loginURL,
        body: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
          isLoggedIn.add(true);
          Map<String,dynamic> body = jsonDecode(response.body);
          print(body);
          // updating the current data in the service.
          var responseUser = UserModel.fromMap(body['user']);
          user.add(responseUser);
          token.add(body["token"]);
          isLoggedIn.add(true);
          //saving the user data of the service
          _saveUserToLocalStore();
          return body;
      } else {
        throw (jsonDecode(response.body));
      }
    } catch (error) {
      return error;
    }
  }
  void logOut(){
      isLoggedIn.add(false);
      user.add(null);
      token.add("");
      _deleteFromLocalStorage();
  }
  void _saveUserToLocalStore(){
    SharedPreferences.getInstance().then((pref){
        pref.setString('token',tokenValue);
        print(userValue.toJson() is String);
        pref.setString('user',userValue.toJson());
        pref.setBool('isLogged',true);
    });
  }
  void _readUserFromLocalStore(){
    SharedPreferences.getInstance().then((pref){
        if(pref.containsKey('isLogged')){
        token.add(pref.getString('token'));
        print(pref.get('user'));
        user.add(UserModel.fromJson(pref.getString('user')));
        isLoggedIn.add(pref.getBool('isLogged'));
        }
    });
  }
  void _deleteFromLocalStorage(){
      SharedPreferences.getInstance().then((pref){
        pref.remove('isLogged');
        pref.remove('token');
        pref.remove('user');
      });
  }
}

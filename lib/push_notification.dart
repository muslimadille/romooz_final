import 'package:firebase_messaging/firebase_messaging.dart';
class PushNotificationManager{
  PushNotificationManager._();
  factory PushNotificationManager() => _instance;
  static final PushNotificationManager _instance = PushNotificationManager._();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  bool _initialized = false;
  Future<bool> init() async{
    if(!_initialized){
      //ios
      // _firebaseMessaging.requestPermission();
      // _firebaseMessaging.configure();


      String token = await _firebaseMessaging.getToken();
      print('-----------------------------------   '+token);
      _initialized = true;
    }
  }
}
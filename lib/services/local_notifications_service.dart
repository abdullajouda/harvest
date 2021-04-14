import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:harvest/helpers/app_shared.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalNotificationsService {
  static LocalNotificationsService _instance;
  var initializationSettings;

  BehaviorSubject<ReceiveNotification> get didReceiveLocalNotificationSubject =>
      BehaviorSubject<ReceiveNotification>();
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  int _id = 0;

  // ||.. private constructor ..||
  LocalNotificationsService._() {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) {
      requestIOSPermission();
    }
    _initLocalNotifications();
    // init();
  }

  // ||.. singleton pattern ..||
  static LocalNotificationsService get instance {
    if (_instance != null) return _instance;
    return _instance = LocalNotificationsService._();
  }

  //init.
  init() async {
    await _initLocalNotifications();
  }

  // local notifications init.
  Future<void> _initLocalNotifications() async {
    var initializationSettingsAndroid =
    AndroidInitializationSettings('@drawable/ic_app');
    var initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: (id, title, body, payload) async {
          ReceiveNotification notification = ReceiveNotification(
              id: id, body: body, title: title, payload: payload);
          didReceiveLocalNotificationSubject.add(notification);
        });
    initializationSettings = InitializationSettings(
       initializationSettingsAndroid, initializationSettingsIOS);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: _selectNotification);
  }

  requestIOSPermission() {
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        .requestPermissions(alert: true, badge: true, sound: true);
  }

  setOnNotificationReceived(Function onReceived) {
    didReceiveLocalNotificationSubject.listen((value) {
      onReceived(value);
    });
  }

  // ||... on local notification clicked ...||
  Future _selectNotification(String payload) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('userToken');
    try {
      Map<String, dynamic> notification =
      await jsonDecode(payload) as Map<String, dynamic>;
      AppShared.notification = null;
    } catch (error) {
      print(error.toString());
    }
  }

  // ||... show local notification ...||
  Future<void> showNotification(String title, String message,
      {String payload}) async {
    var android = AndroidNotificationDetails(
      'ticksId',
      'ticksName',
      'ticksDescription',
      enableVibration: true,
      enableLights: true,
      playSound: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var ios = IOSNotificationDetails();
    var platform = NotificationDetails( android,  ios);
    await _flutterLocalNotificationsPlugin.show(
      ++_id,
      title,
      message,
      platform,
      payload: payload,
    );
  }
}

LocalNotificationsService localNotificationsService =
    LocalNotificationsService.instance;

class ReceiveNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceiveNotification(
      {@required this.id,
        @required this.title,
        @required this.body,
        @required this.payload});
}

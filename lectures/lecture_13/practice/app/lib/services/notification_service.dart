import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:uuid/uuid.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

Future<void> _configureLocalTimeZone() async {
  if (kIsWeb || Platform.isLinux) {
    return;
  }
  tz.initializeTimeZones();
  if (Platform.isWindows) {
    return;
  }
  final String timeZoneName = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

Future<FlutterLocalNotificationsPlugin> initializeNotifications() async {
  var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid = const AndroidInitializationSettings(
      '@drawable/ic_notification'); // TODO: Change this to an icon of your choice if you want to fix it.
  var initializationSettingsDarwin = const DarwinInitializationSettings();
  var initializationSettingsLinux =
  const LinuxInitializationSettings(defaultActionName: 'Open notification');

  const WindowsInitializationSettings initializationSettingsWindows =
      WindowsInitializationSettings(
          appName: 'STI App',
          appUserModelId: 'Com.Example.App',
          guid: '2559e0d4-553e-42b5-869c-7dc6dd5ca003');
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
      windows: initializationSettingsWindows,
      linux: initializationSettingsLinux);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  return flutterLocalNotificationsPlugin;
}

class NotificationsService {
  // singleton

  static Future<NotificationsService> initialize() async {
    if (_instance != null) {
      return _instance!;
    }
    await _configureLocalTimeZone();
    final plugin = await initializeNotifications();
    _instance = NotificationsService._(flutterLocalNotificationsPlugin: plugin);
    return _instance!;
  }

  static NotificationsService? _instance;

  static Future<NotificationsService> get instance => initialize();

  NotificationsService._(
      {required FlutterLocalNotificationsPlugin
          flutterLocalNotificationsPlugin})
      : _plugin = flutterLocalNotificationsPlugin; // private constructor

  final FlutterLocalNotificationsPlugin _plugin;

  Future<void> cancelScheduledNotificaion(int id) async {
    await _plugin.cancel(id);
  }

  Future<void> scheduleNotification(
      {required String title,
      required String content,
      required DateTime deliveryTime,
      required int id}) async {
    await requestPermissions();

    String channelId = const Uuid()
        .v4(); // id should be unique per message, but contents of the same notification can be updated if you write to the same id
    const String channelName =
        "notifications_channel"; // this can be anything, different channels can be configured to have different colors, sound, vibration, we wont do that here
    String channelDescription =
        "Standard notifications"; // description is optional but shows up in user system settings
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        channelId, channelName,
        channelDescription: channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        color: const Color.fromARGB(255, 106, 61, 232),
        when: deliveryTime.millisecondsSinceEpoch,
        chronometerCountDown: true,
        usesChronometer: true);

    // no details needed for macos,linux,windows,ios, they will use defaults from init unless otherwise configured.

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    // from docs, not sure about specifics

    return await _plugin.zonedSchedule(
        id,
        title,
        content,
        tz.TZDateTime.from(deliveryTime,
            tz.local), // TZDateTime required to take daylight savings into considerations.
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle);
  }

  Future<void> requestPermissions() async {
    if (Platform.isIOS) {
      final impl = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      await impl?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    if (Platform.isMacOS) {
      final impl = _plugin.resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin>();
      await impl?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    if (Platform.isAndroid) {
      final impl = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      await impl?.requestNotificationsPermission();
    }
  }
}

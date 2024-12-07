import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Timer? _countdownTimer;


  static Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings settings =
        InitializationSettings(android: androidSettings);

    await _notificationsPlugin.initialize(settings);
    tz.initializeTimeZones();
  }

  static Future<void> startCountdownNotification(DateTime targetDate) async {

    _countdownTimer?.cancel(); // تنظيف المؤقت القديم إذا موجود
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      final Duration newRemainingTime = targetDate.difference(DateTime.now());

      if (newRemainingTime.inSeconds <= 0) {
        timer.cancel();
        _countdownTimer = null;

        // إشعار انتهاء العد التنازلي
        await _notificationsPlugin.show(
          1,
          'Countdown Complete',
          'The countdown has finished!',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'countdown_channel',
              'Countdown Notifications',
              importance: Importance.high,
              priority: Priority.high,
            ),
          ),
        );
      } else {
        // تحديث الإشعار بالوقت المتبقي
        await _notificationsPlugin.show(
          1,
          'Countdown In Progress',
          '${newRemainingTime.inHours.toString().padLeft(2, '0')}:' 
          '${(newRemainingTime.inMinutes % 60).toString().padLeft(2, '0')}:' 
          '${(newRemainingTime.inSeconds % 60).toString().padLeft(2, '0')} remaining',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'countdown_channel',
              'Countdown Notifications',
              importance: Importance.high,
              priority: Priority.high,
              onlyAlertOnce: true,
            ),
          ),
        );
      }
    });
  }

  static Future<void> cancelCountdown() async {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    await _notificationsPlugin.cancel(1);
  }

  static Future<void> clearAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  static Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final pendingNotifications = await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return pendingNotifications; // تأكد من أن هذه الدالة ترجع قائمة صحيحة
  }

  static Future<void> clearNotificationById(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  static Future<void> showInstantNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'instant_channel',
      'Instant Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails details = NotificationDetails(android: androidDetails);
    await _notificationsPlugin.show(0, title, body, details);
  }

  static Future<void> scheduleNotification(
    int id, String title, String body, DateTime scheduledTime) async {
    try {
      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledTime, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'scheduled_channel',
            'Scheduled Notifications',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        // androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e) {
      print("Error Scheduling Notification: $e");
    }
  }
}

import 'package:flutter/material.dart';
import '../services/notification_service.dart';

class ClearButton extends StatelessWidget {
  const ClearButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: ()  {
         NotificationService.clearAllNotifications();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All notifications cleared!'),
            backgroundColor: Colors.redAccent,
          ),
        );
      },
      icon: const Icon(
        Icons.delete_forever,
        color: Colors.white,
      ),
      label: const Text(
        'Clear All Notifications',
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red[700],
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

//getx diulog
import 'package:get/get.dart';

class Modal {
  static void showFlushbar({
    required BuildContext context,
    required String message,
    Color backgroundColor = Colors.black87,
    IconData? icon,
    Duration duration = const Duration(seconds: 2),
  }) {
    Flushbar(
      message: message,
      backgroundColor: backgroundColor,
      icon: icon != null ? Icon(icon, color: Colors.white) : null,
      duration: duration,
      margin: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(8),
      flushbarPosition: FlushbarPosition.TOP,
    ).show(context);
  }

  static void showSuccess(BuildContext context, String message) {
    showFlushbar(
      context: context,
      message: message,
      backgroundColor: Colors.green.shade600,
      icon: Icons.check_circle,
    );
  }

  static void showError(BuildContext context, String message) {
    showFlushbar(
      context: context,
      message: message,
      backgroundColor: Colors.red.shade600,
      icon: Icons.error,
    );
  }

  static void showInfo(BuildContext context, String message) {
    showFlushbar(
      context: context,
      message: message,
      backgroundColor: Colors.blue.shade600,
      icon: Icons.info,
    );
  }

  static void showSuccessModal({
    String title = 'Success',
    String message = 'Operation completed successfully.',
    VoidCallback? onClose,
    bool showButton = false,
    String buttonText = 'OK',
  }) {
    Get.dialog(
      AlertDialog(
        title: Text(title, style: const TextStyle(color: Colors.green)),
        content: Text(message),
        actions: [
          if (showButton)
            TextButton(
              onPressed: () {
                Get.back();
                if (onClose != null) onClose();
              },
              child: Text(buttonText),
            ),
        ],
      ),
      barrierDismissible: !showButton,
    );
  }

  static void showErrorModal({
    String title = 'Error',
    String message = 'An error occurred.',
    VoidCallback? onClose,
    bool showButton = false,
    String buttonText = 'OK',
  }) {
    Get.dialog(
      AlertDialog(
        title: Text(title, style: const TextStyle(color: Colors.red)),
        content: Text(message),
        actions: [
          if (showButton)
            TextButton(
              onPressed: () {
                Get.back();
                if (onClose != null) onClose();
              },
              child: Text(buttonText),
            ),
        ],
      ),
      barrierDismissible: !showButton,
    );
  }

  static void showConfirmationModal({
    String title = 'Confirmation',
    String message = 'Are you sure you want to proceed?',
    String cancelText = 'Cancel',
    String confirmText = 'Confirm',
    VoidCallback? onCancel,
    VoidCallback? onConfirm,
    bool isDangerousAction = false,
  }) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              if (onCancel != null) onCancel();
            },
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              if (onConfirm != null) onConfirm();
            },
            child: Text(confirmText, style: TextStyle(color: isDangerousAction ? Colors.red : Colors.blue)),
          ),
        ],
      ),
    );
  }

  static void showInfoModal({
    String title = 'Information',
    String message = 'Information',
    VoidCallback? onClose,
    String buttonText = 'OK',
  }) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              if (onClose != null) onClose();
            },
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
}

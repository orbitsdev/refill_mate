import 'package:flutter/material.dart';

//getx diulog
class Modal {
  static void showSuccessModal({
    String title = 'Success',
    String message = 'Operation completed successfully.',
    VoidCallback? onClose,
    bool showButton = false,
    String buttonText = 'OK',
  }) {}

  /// 

  static void showErrorModal({
    String title = '  Error',
    String message = 'Operation completed successfully.',
    VoidCallback? onClose,
    bool showButton = false,
    String buttonText = 'OK',
  }) {}

    static void showConfirmationModal({
    String title = 'Confirmation',
    String message = 'Are you sure you want to proceed?',
    String cancelText = 'Cancel',
    String confirmText = 'Confirm',
    VoidCallback? onCancel,
    VoidCallback? onConfirm,
    bool isDangerousAction = false,
  }) {

  }


  static void showInfoModal({
    String title = 'Information',
    String message = 'Information',
    VoidCallback? onClose,
    String buttonText = 'OK',
  }) {

  }
}

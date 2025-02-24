import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  final permission = Permission.notification;

  Future<bool> requestNotificationsPermission() async {
    if (await permission.isDenied) {
      await permission.request();
    }
    return permission.isGranted;
  }

  // Check if permission is granted
  Future<bool> isPermissionGranted() async {
    return await permission.status.isGranted;
  }

  // Check if permission is denied
  Future<bool> isPermissionDenied() async {
    return await permission.status.isDenied;
  }

  // Choose whether we should show explanation before requesting permission
  Future<bool> shouldShowRequestRationale() async {
    return await permission.shouldShowRequestRationale;
  }

  // Check if the notification permission is permanently denied or not
  Future<bool> checkPermanentlyDenied() async {
    return await permission.status.isPermanentlyDenied;
  }
}

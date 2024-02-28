import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandler extends ChangeNotifier {
  PermissionHandler._(); // Private constructor
  static final _instance = PermissionHandler._(); // Static instance

  factory PermissionHandler() {
    // Factory constructor to return the instance
    return _instance;
  }

  final _permissionQueue = Queue<Permission>();
  bool _permissionRequested = false;

  Future<bool> _requestPermission(Permission permission) async {
    final isPermissionGranted = await permission.status.isGranted;
    if (!isPermissionGranted) {
      final result = await permission.request();
      return result.isGranted;
    }
    // Permission already granted
    return true;
  }

  void _processQueue() async {
    while (_permissionQueue.isNotEmpty) {
      final permission = _permissionQueue.removeFirst();
      final granted = await _requestPermission(permission);
      if (!granted) {
        // Handle the denied permission or notify the user
        break; // or continue, depending on your app's requirement
      }
      notifyListeners();
    }
  }

  void requestPermissions(List<Permission> permissions) async {
    if (_permissionRequested) {
      await openAppSettings();
      return;
    }
    _permissionRequested = true;
    _permissionQueue.addAll(permissions);
    _processQueue();
  }

  void refresh() {
    notifyListeners();
  }
}

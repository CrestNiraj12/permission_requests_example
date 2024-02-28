import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_requests_example/service/permission_handler.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  final _permission = PermissionHandler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Permission Requests Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () {
                final permissionHandler = PermissionHandler();
                permissionHandler.requestPermissions([
                  Permission.camera,
                  Permission.microphone,
                ]);
              },
              child: const Text('Request Permission'),
            ),
            const SizedBox(height: 20),
            ListenableBuilder(
              listenable: _permission,
              builder: (ctx, _) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<PermissionStatus>(
                    future: Permission.camera.status,
                    builder: (ctx, snapshot) {
                      if (snapshot.hasData) {
                        return Text('Camera: ${snapshot.data!}');
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  FutureBuilder<PermissionStatus>(
                    future: Permission.microphone.status,
                    builder: (ctx, snapshot) {
                      if (snapshot.hasData) {
                        return Text('Microphone: ${snapshot.data!}');
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            OutlinedButton(
              onPressed: () {
                _permission.refresh();
              },
              child: const Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }
}

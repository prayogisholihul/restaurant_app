import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/controller/home_controller.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final HomeController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: Colors.white,
          icon: defaultTargetPlatform == TargetPlatform.iOS
              ? const Icon(CupertinoIcons.back)
              : const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: ListTile(
            title: const Text('Scheduling Restaurant at 11.00'),
            trailing: Obx(() => Switch.adaptive(
                value: controller.isScheduled.value,
                onChanged: (value) {
                  if (Platform.isIOS) {
                    print('Coming Soon');
                  } else {
                    controller.scheduled(value);
                  }
                }))),
      )),
    );
  }
}

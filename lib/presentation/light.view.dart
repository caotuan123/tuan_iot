import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:iot_app/controller/light_controller.dart';

class LightUI extends StatelessWidget {
  final controller = Get.put(LightController());
  LightUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IOT'),
      ),
      body: StreamBuilder<Object>(
          stream: controller.lightStatusStream(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              final bool newStatus = controller.statusFromServer(snapshot);
              controller.setStatusLight(newStatus);
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    newStatus
                        ? Image.asset("asset/image/light_on.png", height: 100)
                        : Image.asset("asset/image/light_off.png", height: 100),
                    const SizedBox(
                      height: 50,
                    ),
                    CupertinoSwitch(
                      value: controller.light.value.status,
                      onChanged: (newStatus) {
                        controller.setStatusLight(newStatus);
                      },
                    ),
                  ],
                ),
              );
            }
            return const SizedBox();
          }),
    );
  }


}

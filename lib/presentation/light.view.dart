import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:iot_app/controller/iot_controller.dart';

class LightUI extends StatelessWidget {
  final controller = Get.put(IoTController());
  LightUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IOT'),
      ),
      body: StreamBuilder<Object>(
          stream: controller.ioTStream(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              // Only check false or true
              controller.statusFromServer(snapshot);
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        controller.statusLight
                            ? Image.asset("asset/image/light_on.png", height: 100)
                            : Image.asset("asset/image/light_off.png", height: 100),
                        const SizedBox(
                          height: 50,
                        ),
                        CupertinoSwitch(
                          value: controller.statusLight,
                          onChanged: (newStatus) async {
                            await controller.setStatusLight(newStatus);
                          },
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        controller.statusLock
                            ? Image.asset("asset/image/lock_open.png", height: 100)
                            : Image.asset("asset/image/lock_close.png", height: 100),
                        const SizedBox(
                          height: 50,
                        ),
                        CupertinoSwitch(
                          value: controller.statusLock,
                          onChanged: (newStatus) async {
                            await controller.setStatusLock(newStatus);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
            return const SizedBox();
          }),
    );
  }
}

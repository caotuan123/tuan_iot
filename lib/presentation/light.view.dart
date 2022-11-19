import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:iot_app/controller/iot_controller.dart';

class LightUI extends StatelessWidget {
  final controller = Get.put(IoTController());//de truyen data vao
  LightUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IOT'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
        child: StreamBuilder<Object>(
            stream: controller.listDeviceStream(),//stream luon thay doi 
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasData) {
                // Only check false or true
                controller.getDataFromServer(snapshot);
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
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
                        Column(
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
                      ],
                    ),
                    Column(
                      children: [
                        Image.asset(
                          'asset/image/rfid.png',
                          height: 250,
                          width: 250,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () => controller.newID(),
                              style: ElevatedButton.styleFrom(primary: Colors.orangeAccent),
                              child: const Text('Create new user', style: TextStyle(fontSize: 17)),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: () => controller.deleteID(),
                              style: ElevatedButton.styleFrom(primary: Colors.orangeAccent),
                              child: const Text('Delete new user', style: TextStyle(fontSize: 17)),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                );
              }
              return const SizedBox();
            }),
      ),
    );
  }
}

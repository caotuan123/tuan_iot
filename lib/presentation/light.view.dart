import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:iot_app/controller/iot_controller.dart';

class LightWidget extends StatelessWidget {
  final String iconVar;
  final String textVar;
  final String valuVar;
  final String unitVar;
  final Color box_color;
  double box_heigh = 140;
  double box_width = 180;
  LightWidget({
    required this.iconVar,
    required this.textVar,
    required this.unitVar,
    required this.valuVar,
    required this.box_color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: box_width,
      height: box_heigh,
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        color: box_color,
        margin: const EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Image.asset(
                iconVar,
                height: box_heigh / 4,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(valuVar,
                    style: const TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    )),
                Text(unitVar,
                    style: const TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
            Text(textVar,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )),
          ],
        ),
      ),
    );
  }
}

class LightUI extends StatelessWidget {
  final controller = Get.put(IoTController()); //de truyen data vao
  LightUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 0),
        child: StreamBuilder<Object>(
            stream: controller.listDeviceStream(), //stream luon thay doi
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LightWidget(
                          iconVar: "asset/icon/icon_temperature.png",
                          textVar: "Home temperature",
                          valuVar: controller.valueTemp ?? '0',
                          unitVar: "°C",
                          box_color: Colors.green,
                        ),
                        LightWidget(
                          iconVar: "asset/icon/icon_temperature.png",
                          textVar: "Home temperature",
                          valuVar: controller.valueTemp ?? '0',
                          unitVar: "°C",
                          box_color: Colors.blue,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LightWidget(
                          iconVar: "asset/icon/icon_temperature.png",
                          textVar: "Home temperature",
                          valuVar: controller.valueTemp ?? '0',
                          unitVar: "°C",
                          box_color: Colors.blue,
                        ),
                        LightWidget(
                          iconVar: "asset/icon/icon_temperature.png",
                          textVar: "Home temperature",
                          valuVar: controller.valueTemp ?? '0',
                          unitVar: "°C",
                          box_color: Colors.blue,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                            splashColor: Colors.black26,
                            onTap: () async {
                              await controller
                                  .setStatusLight0(!controller.statusLight0);
                            },
                            child: Ink.image(
                              image: AssetImage(controller.statusLight0
                                  ? "asset/image/light_on.png"
                                  : "asset/image/light_off.png"),
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                            )),
                        InkWell(
                            splashColor: Colors.black26,
                            onTap: () async {
                              await controller
                                  .setStatusLight1(!controller.statusLight0);
                            },
                            child: Ink.image(
                              image: AssetImage(controller.statusLight1
                                  ? "asset/image/light_on.png"
                                  : "asset/image/light_off.png"),
                              width: 100,
                              height: 100,
                            )),
                        InkWell(
                            splashColor: Colors.black26,
                            onTap: () async {
                              await controller
                                  .setStatusLock(!controller.statusLock);
                            },
                            child: Ink.image(
                              image: AssetImage(controller.statusLock
                                  ? "asset/image/lock_open.png"
                                  : "asset/image/lock_close.png"),
                              width: 100,
                              height: 100,
                            )),
                      ],
                    ),
                    Column(
                      children: [
                        Image.asset(
                          'asset/image/rfid.png',
                          height: 150,
                          width: 150,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () => controller.newID(),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.greenAccent),
                              child: const Text('Create new user',
                                  style: TextStyle(fontSize: 17)),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: () => controller.deleteID(),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.redAccent),
                              child: const Text('Delete user',
                                  style: TextStyle(fontSize: 17)),
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

// ignore_for_file: non_constant_identifier_names, constant_identifier_names

abstract class StatusEnum {
  static const String ON = 'ON';
  static const String OFF = 'OFF';
  static const String OPEN = 'OPEN';
  static const String CLOSED = 'CLOSE';
}

abstract class DeviceEnum {
  static const String light = 'light';
  static const String lock = 'lock';

}

abstract class TypeNotifyEnum {
  static const int TypeUpdate = 0;
  static const int TypeCmd = 1;
  static const int TypeRes = 2;
  static const int TypeReq = 3;
}

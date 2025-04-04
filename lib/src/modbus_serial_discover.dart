import 'package:modbus_client/modbus_client.dart';
import 'package:modbus_client_serial_android/modbus_client_serial_android.dart';

import 'package:usb_serial/usb_serial.dart';

enum ModbusType { rtu, ascii }

Future<String?> discover(
    {required int unitId,
    required ModbusType type,
    SerialBaudRate baudRate = SerialBaudRate.b19200,
    SerialDataBits dataBits = SerialDataBits.bits8,
    SerialStopBits stopBits = SerialStopBits.one,
    SerialParity parity = SerialParity.none,
    SerialFlowControl flowControl = SerialFlowControl.rtsCts,
    Duration responseTimeout = const Duration(seconds: 1),
    bool flushOnRequest = true}) async {
  var dummyRequest = ModbusInt16Register(
          address: 1,
          name: "dummy register",
          type: ModbusElementType.holdingRegister)
      .getReadRequest(unitId: unitId, responseTimeout: responseTimeout);
  for (var dev in await UsbSerial.listDevices()) {
    late ModbusClientSerial client;
    if (type == ModbusType.rtu) {
      client = ModbusClientSerialRtu(
          portName: dev.deviceName,
          baudRate: baudRate,
          dataBits: dataBits,
          stopBits: stopBits,
          parity: parity,
          flowControl: flowControl,
          flushOnRequest: flushOnRequest);
    } else {
      client = ModbusClientSerialAscii(
          portName: dev.deviceName,
          baudRate: baudRate,
          dataBits: dataBits,
          stopBits: stopBits,
          parity: parity,
          flowControl: flowControl,
          flushOnRequest: flushOnRequest);
    }
    var res = await client.send(dummyRequest);
    if (res == ModbusResponseCode.requestSucceed ||
        res.isStandardModbusExceptionCode) {
      return dev.deviceName;
    }
  }
  return null;
}

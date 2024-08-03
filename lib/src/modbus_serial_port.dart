import 'dart:async';
import 'dart:typed_data';

import 'package:modbus_client/modbus_client.dart';
import 'package:modbus_client_serial_android/modbus_client_serial_android.dart';
import 'package:usb_serial/usb_serial.dart';

/// serial port client implementation
class UsbSerialPort extends ModbusSerialPort {
  final SerialBaudRate baudRate;
  final SerialDataBits dataBits;
  final SerialStopBits stopBits;
  final SerialParity parity;
  final SerialFlowControl flowControl;
  UsbPort? _usbPort;

  UsbSerialPort(this.name, this.baudRate, this.dataBits, this.stopBits,
      this.parity, this.flowControl);

  /// The serial port name
  @override
  final String name;

  @override
  bool get isOpen => _usbPort != null;

  /// Opens the serial port for reading and writing.
  @override
  Future<bool> open() async {
    if (_usbPort != null) {
      _usbPort!.close();
      _usbPort = null;
    }

    final androidUsbDevice =
        (await UsbSerial.listDevices()).firstWhere((d) => d.deviceName == name);
    _usbPort = await androidUsbDevice.create();
    if (_usbPort == null) {
      return false;
    }
    var opened = await _usbPort!.open();
    if (!opened) {
      _usbPort!.close();
      _usbPort = null;
      return false;
    }

    _usbPort!.setFlowControl(flowControl.intValue);
    _usbPort!.setPortParameters(
      baudRate.intValue,
      dataBits.intValue,
      stopBits.intValue,
      parity.intValue,
    );
    return true;
  }

  @override
  Future<void> close() async {
    if (_usbPort != null) {
      _usbPort!.close();
      _usbPort = null;
    }
  }

  @override
  Future<void> flush() async {
    // N/A
  }

  @override
  Future<Uint8List> read(int bytes, {Duration? timeout}) async {
    if (_usbPort != null) {
      List<int> inData = [];
      final completer = Completer<Uint8List>();

      StreamSubscription<List<int>> subscription;
      subscription = _usbPort!.inputStream!.listen((data) {
        inData.addAll(data);
        if (inData.length >= bytes) {
          completer.complete(Uint8List.fromList(inData));
        }
      }, onError: (error) {
        completer.completeError(error);
      }, cancelOnError: true);
      var rxData = await completer.future
          .timeout(timeout ?? const Duration(seconds: 60), onTimeout: () {
        subscription.cancel();
        return Uint8List.fromList(inData);
      });
      try {
        subscription.cancel();
      } catch (_) {}
      return rxData;
    }
    return Uint8List(0);
  }

  @override
  Future<int> write(Uint8List bytes, {Duration? timeout}) async {
    if (_usbPort != null) {
      await _usbPort!
          .write(bytes)
          .timeout(timeout ?? const Duration(seconds: 60));
      return bytes.length; // TODO: how to get the written data amout?
    }
    return 0;
  }
}

library modbus_client_serial;

import 'package:modbus_client/modbus_client.dart';
import 'package:usb_serial/usb_serial.dart';

export 'src/modbus_client_serial_ascii.dart';
export 'src/modbus_client_serial_rtu.dart';
export 'src/modbus_serial_port.dart';

/// Serial baud rates definition
enum SerialBaudRate implements ModbusIntEnum {
  b200(200),
  b300(300),
  b600(600),
  b1200(1200),
  b1800(1800),
  b2400(2400),
  b4800(4800),
  b9600(9600),
  b19200(19200),
  b28800(28800),
  b38400(38400),
  b57600(57600),
  b76800(76800),
  b115200(115200),
  b230400(230400),
  b460800(460800),
  b576000(576000),
  b921600(921600);

  const SerialBaudRate(this.intValue);

  @override
  final int intValue;
}

/// Serial data bits definition
enum SerialDataBits implements ModbusIntEnum {
  bits5(5),
  bits6(6),
  bits7(7),
  bits8(8),
  bits9(9);

  const SerialDataBits(this.intValue);

  @override
  final int intValue;
}

/// Serial stop bits definition
enum SerialStopBits implements ModbusIntEnum {
  none(0),
  one(UsbPort.STOPBITS_1),
  oneAndHalf(UsbPort.STOPBITS_1_5),
  two(UsbPort.STOPBITS_2);

  const SerialStopBits(this.intValue);

  @override
  final int intValue;
}

/// Serial parity definition
enum SerialParity implements ModbusIntEnum {
  none(UsbPort.PARITY_NONE),
  odd(UsbPort.PARITY_ODD),
  even(UsbPort.PARITY_EVEN),
  mark(UsbPort.PARITY_MARK),
  space(UsbPort.PARITY_SPACE);

  const SerialParity(this.intValue);

  @override
  final int intValue;
}

/// Serial flow control definition
enum SerialFlowControl implements ModbusIntEnum {
  none(UsbPort.FLOW_CONTROL_OFF),
  xonXoff(UsbPort.FLOW_CONTROL_XON_XOFF),
  rtsCts(UsbPort.FLOW_CONTROL_RTS_CTS),
  dtrDsr(UsbPort.FLOW_CONTROL_DSR_DTR);

  const SerialFlowControl(this.intValue);

  @override
  final int intValue;
}

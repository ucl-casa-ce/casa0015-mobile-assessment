//Adapted from https://blog.kuzzle.io/communicate-through-ble-using-flutter

//import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermissions() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.location,
  ].request();

  final locationPermission = statuses[Permission.location];
  if (locationPermission != PermissionStatus.granted) {
    throw Exception('Location permission not granted');
  }
}

class BLEConnect extends StatefulWidget {
  BLEConnect({
    super.key,
    required this.title,
    required this.onConnectionStatusChanged,
    required this.onDataReceived
  });

  final String title;
  final List<BluetoothDevice> devicesList = <BluetoothDevice>[];
  final Map<Guid, List<int>> readValues = <Guid, List<int>>{};
  String hrValues = "";

  // Callbacks
  final Function(bool isConnected) onConnectionStatusChanged;
  final Function(String data) onDataReceived;

  @override
  BLEConnectState createState() => BLEConnectState();
}

class BLEConnectState extends State<BLEConnect> {
  final _writeController = TextEditingController();
  BluetoothDevice? _connectedDevice;
  List<BluetoothService> _services = [];

  _addDeviceTolist(final BluetoothDevice device) {
    if (!widget.devicesList.contains(device)) {
      setState(() {
        widget.devicesList.add(device);
      });
    }
  }

  _initBluetooth() async {
    var subscription = FlutterBluePlus.onScanResults.listen(
          (results) {
        if (results.isNotEmpty) {
          for (ScanResult result in results) {
            _addDeviceTolist(result.device);
          }
        }
      },
      onError: (e) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      ),
    );

    FlutterBluePlus.cancelWhenScanComplete(subscription);

    await FlutterBluePlus.adapterState
        .where((val) => val == BluetoothAdapterState.on)
        .first;

    await FlutterBluePlus.startScan();

    await FlutterBluePlus.isScanning.where((val) => val == false).first;
    FlutterBluePlus.connectedDevices.map((device) {
      _addDeviceTolist(device);
    });
  }

  // get Heart Rate Values
  void printCharacteristicValues(BluetoothCharacteristic characteristic) async {
    var sub = characteristic.lastValueStream.listen((value) {
      setState(() {
        widget.readValues[characteristic.uuid] = value;
        widget.hrValues = String.fromCharCodes(value);
      });
    });
    await characteristic.read();
    sub.cancel();
  }

  void printValues(List<int> values) {
    print("The values: $values");
    print(String.fromCharCodes(values));
  }

  void listenToCharacteristic(BluetoothCharacteristic characteristic) async {
    // Check if this characteristic supports notifications
    if (characteristic.properties.notify) {
      // Subscribe to notifications
      await characteristic.setNotifyValue(true);

      // Listen for changes to the characteristic's value
      characteristic.lastValueStream.listen((value) {
        // Do something with the new value
        print("New characteristic value: $value");
        printValues(value);
      });
    }
  }

  @override
  void initState() {

    () async {
      await requestPermissions();

      var status = await Permission.location.status;
      if (status.isDenied) {
        final status = await Permission.location.request();
        if (status.isGranted || status.isLimited) {
          _initBluetooth();
        }
      } else if (status.isGranted || status.isLimited) {
        _initBluetooth();
      }

      if (await Permission.location.status.isPermanentlyDenied) {
        openAppSettings();
      }
    }();
    super.initState();
  }

  ListView _buildListViewOfDevices() {
    List<Widget> containers = <Widget>[];
    for (BluetoothDevice device in widget.devicesList) {
      //only display devices that are CalmerBeats Heart Beat Monitors, i.e. advertise "BeatsMon".
      if (device.advName == "BeatsMon") {
        print(device.advName);
        containers.add(
          SizedBox(
            height: 50,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(device.platformName == ''
                          ? '(unknown device)'
                          : device.advName),
                      Text(device.remoteId.toString()),
                    ],
                  ),
                ),
                TextButton(
                  child: const Text(
                    'Connect',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () async {
                    FlutterBluePlus.stopScan();
                    try {
                      await device.connect();
                      //inform the parent route connection is made
                      widget.onConnectionStatusChanged(true);
                    } on PlatformException catch (e) {
                      if (e.code != 'already_connected') {
                        rethrow;
                      }
                    } finally {
                      _services = await device.discoverServices();
                    }

                    setState(() {
                      _connectedDevice = device;
                    });

                    // loop to find the right one.
                    for (var service in _services) {
                      var characteristics = service.characteristics;
                      for (var characteristic in characteristics) {
                        if (characteristic.properties.notify) {
                          await characteristic.setNotifyValue(true);
                          characteristic.lastValueStream.listen((value) {
                            setState(() {
                              widget.readValues[characteristic.uuid] = value;
                              widget.hrValues = String.fromCharCodes(value);
                              //trigger the callback with data
                              widget.onDataReceived(widget.hrValues);
                            });
                          });
                        }
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        );
      }
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ...containers,
      ],
    );
  }

  ListView _buildConnectDeviceView() {
    List<Widget> containers = <Widget>[];

    for (BluetoothService service in _services) {
      List<Widget> characteristicsWidget = <Widget>[];

      for (BluetoothCharacteristic characteristic in service.characteristics) {
        characteristicsWidget.add(
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(characteristic.uuid.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                /*Row(
                  children: <Widget>[
                    ..._buildReadWriteNotifyButton(characteristic),
                  ],
                ),
                */
                Row(
                  children: <Widget>[
                    //Expanded(child: Text('Value: ${widget.readValues[characteristic.uuid]}')),
                    Expanded(child: Text('Value: ${widget.hrValues}')),
                  ],
                ),
                const Divider(),
              ],
            ),
          ),
        );
      }
      containers.add(
        ExpansionTile(
            title: Text(service.uuid.toString()),
            children: characteristicsWidget),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ...containers,
      ],
    );
  }

  ListView _buildView() {
    if (_connectedDevice != null) {
      return _buildConnectDeviceView();
    }
    return _buildListViewOfDevices();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    //appBar: AppBar(
    //  title: Text(widget.title),
    //),

    body: _buildView(),

  );
}

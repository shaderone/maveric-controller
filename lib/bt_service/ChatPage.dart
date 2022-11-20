import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

const primaryColor = Color.fromARGB(255, 0, 217, 255);

class ChatPage extends StatefulWidget {
  final BluetoothDevice server;

  const ChatPage({required this.server});

  @override
  _ChatPage createState() => _ChatPage();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _ChatPage extends State<ChatPage> {
  static const clientID = 0;
  BluetoothConnection? connection;

  List<_Message> messages = List<_Message>.empty(growable: true);
  String _messageBuffer = '';

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();

  bool isConnecting = true;
  bool get isConnected => (connection?.isConnected ?? false);

  bool isDisconnecting = false;

  @override
  void initState() {
    super.initState();

    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

      connection!.input!.listen(_onDataReceived).onDone(() {
        // Example: Detect which side closed the connection
        // There should be `isDisconnecting` flag to show are we are (locally)
        // in middle of disconnecting process, should be set before calling
        // `dispose`, `finish` or `close`, which all causes to disconnect.
        // If we except the disconnection, `onDone` should be fired as result.
        // If we didn't except this (no flag set), it means closing by remote.
        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
        if (this.mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection?.dispose();
      connection = null;
    }

    super.dispose();
  }

  bool start = false;
  @override
  Widget build(BuildContext context) {
    //final serverName = widget.server.name ?? "Unknown";
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Maverick Controller",
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              fontSize: 22,
              color: primaryColor,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFF2A2F40),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF3B4259).withOpacity(.90),
              const Color(0xFF2A2F40),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              ListTile(
                leading: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Overall Status",
                      style: TextStyle(fontSize: 16),
                    ),
                    Text("GOOD",
                        style: GoogleFonts.odibeeSans(
                          textStyle: const TextStyle(
                            fontSize: 32,
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  ],
                ),
                trailing: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset("lib/hexabg.png"),
                    IconButton(
                      onPressed: () {
                        // update icon color
                        setState(() {
                          start = !start;
                        });
                        _sendMessage(start ? "1" : "0");
                      },
                      icon: Icon(
                        start
                            ? MdiIcons.powerPlug
                            : MdiIcons.powerPlugOffOutline,
                        color: start ? Colors.amber : Colors.white,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  children: const [
                    StatsCard(
                      statTitle: "BATTERY STATS",
                      statIcon: MdiIcons.carBattery,
                      statItems: [
                        StatChip(chipTitle: "Temperature", chipText: "54C"),
                        SizedBox(width: 10),
                        StatChip(chipTitle: "Health", chipText: "GOOD"),
                        SizedBox(width: 10),
                        StatChip(chipTitle: "Remaining", chipText: "69%")
                      ],
                    ),
                    SizedBox(height: 10),
                    StatsCard(
                      statTitle: "MOTOR STATS",
                      statIcon: MdiIcons.turbine,
                      statItems: [
                        StatChip(chipTitle: "Temperature", chipText: "54C"),
                        SizedBox(width: 10),
                        StatChip(chipTitle: "Health", chipText: "GOOD"),
                      ],
                    ),
                    SizedBox(height: 10),
                    StatsCard(
                      statTitle: "TIRE STATS",
                      statIcon: MdiIcons.tire,
                      statItems: [
                        StatChip(chipTitle: "Front Left", chipText: "32.8 psi"),
                        SizedBox(width: 10),
                        StatChip(
                            chipTitle: "Front Right", chipText: "33.2 psi"),
                        SizedBox(width: 10),
                        StatChip(chipTitle: "Rear Left", chipText: "33 psi"),
                        SizedBox(width: 10),
                        StatChip(chipTitle: "Rear Right", chipText: "32 psi"),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 80,
        child: Card(
          color: const Color(0xFF1D202C),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Positioned(
                top: -30,
                child: Image.asset("lib/maverick.png"),
              ),
              const Positioned(
                bottom: 10,
                child: Text(
                  "MAVERICKS",
                  style: TextStyle(
                    color: Color(0xFF26D5FB),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(13);
    if (~index != 0) {
      setState(() {
        messages.add(
          _Message(
            1,
            backspacesCounter > 0
                ? _messageBuffer.substring(
                    0, _messageBuffer.length - backspacesCounter)
                : _messageBuffer + dataString.substring(0, index),
          ),
        );
        _messageBuffer = dataString.substring(index);
      });
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }
  }

  void _sendMessage(String text) async {
    text = text.trim();
    textEditingController.clear();

    if (text.isNotEmpty) {
      try {
        connection!.output.add(Uint8List.fromList(utf8.encode("$text\r\n")));
        await connection!.output.allSent;

        setState(() {
          messages.add(_Message(clientID, text));
        });

        Future.delayed(const Duration(milliseconds: 333)).then((_) {
          listScrollController.animateTo(
              listScrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 333),
              curve: Curves.easeOut);
        });
      } catch (e) {
        // Ignore error, but notify state
        setState(() {});
      }
    }
  }
}

class StatsCard extends StatelessWidget {
  final String statTitle;
  final IconData statIcon;
  final List<Widget> statItems;
  const StatsCard({
    Key? key,
    required this.statTitle,
    required this.statIcon,
    required this.statItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 5),
          dense: true,
          leading: Text(
            statTitle,
            style: GoogleFonts.k2d(textStyle: const TextStyle(fontSize: 18)),
          ),
          trailing: Icon(statIcon, color: Colors.white),
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: const Color(0xFf1D202C),
          child: ClipPath(
            clipper: ShapeBorderClipper(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(color: primaryColor, width: 8),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(children: statItems),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class StatChip extends StatelessWidget {
  final String chipTitle;
  final String chipText;
  const StatChip({
    Key? key,
    required this.chipTitle,
    required this.chipText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          chipTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          //style: GoogleFonts.monda(
          //  textStyle: const TextStyle(
          //    color: Colors.white,
          //    fontSize: 16,
          //  ),
          //),
        ),
        Chip(
          backgroundColor: const Color(0xFf3C445D),
          label: Text(chipText,
              style: GoogleFonts.k2d(
                textStyle: const TextStyle(color: Color(0xFf26D5FB)),
              )),
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
        ),
      ],
    );
  }
}

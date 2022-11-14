import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

const primaryColor = Color.fromARGB(255, 0, 217, 255);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          bodyText2: TextStyle(color: Colors.white),
        ),
      ),
      home: const Root(),
    );
  }
}

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  bool start = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Maverick Controller",
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                fontSize: 22,
                color: primaryColor,
              ),
            )),
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

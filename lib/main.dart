import 'package:flutter/material.dart';

const primaryColor = Color.fromARGB(255, 0, 217, 255);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Maverick Controller",
          style: TextStyle(
            fontSize: 22,
            color: Color.fromARGB(255, 0, 170, 255),
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
              ListTile(
                leading: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Overall Status"),
                    Text("GOOD"),
                  ],
                ),
                trailing: const Icon(Icons.power),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  children: [
                    Column(
                      children: [
                        const ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 5),
                          dense: true,
                          leading: Text("Battery Status"),
                          trailing: Icon(Icons.battery_0_bar),
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
                              decoration: const BoxDecoration(
                                border: Border(
                                  left:
                                      BorderSide(color: primaryColor, width: 8),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  children: [
                                    Column(
                                      children: const [
                                        Text(
                                          "Temperature",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Chip(
                                          label: Text("54C"),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 15,
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      children: const [
                                        Text(
                                          "Health",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Chip(
                                          label: Text("GOOD"),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 15,
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      children: const [
                                        Text(
                                          "Remaining",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Chip(
                                          label: Text("58%"),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 15,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

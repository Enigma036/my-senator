import 'package:flutter/material.dart';
import 'package:pilot/dialogs/location_dialog.dart';
import 'package:pilot/geolocation/geolocation.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    Future<bool> isGPSEnabled() async {
      final geolocation = Geolocation();
      final isLocationEnabled = await geolocation.determinePosition();
      return isLocationEnabled;
    }

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.15),
            child: Center(
              child: Image.asset(
                "assets/img/senate.png",
                width: screenWidth * 0.8,
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.15),
              child: GestureDetector(
                onTap: () async {
                  final isLocationEnabled = await isGPSEnabled();
                  if (isLocationEnabled) {
                    if (context.mounted) {
                      Navigator.pushNamed(context, "/senator");
                    }
                  } else {
                    if (context.mounted) {
                      showDialog(
                          context: context,
                          builder: (context) => LocationDialog(
                              title: 'Nelze načíst polohu',
                              text:
                                  'Aplikace nemůže načíst vaši polohu. Ověřte, zda máte zapnutou polohu, popřípadě povolte aplikaci přístup k polohovým službám.'));
                    }
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  decoration: BoxDecoration(
                      color: Color(0xff003876),
                      borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    "Zjistit mého senátora",
                    style: TextStyle(
                        color: Colors.white, fontSize: screenWidth * 0.05),
                  ),
                ),
              )),
          Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.25),
            child: Text(
              "UPOZORNĚNÍ: NEJEDNÁ SE O OFICIÁLNÍ APLIKACI SENÁTU ČR",
              style: TextStyle(
                color: Color(0xff003876),
                fontSize: screenWidth * 0.025,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.02),
            child: Text(
              "Vytvořil Tomáš Hanák",
              style: TextStyle(
                color: Color(0xff003876),
                fontSize: screenWidth * 0.04,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

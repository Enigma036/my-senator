import 'package:flutter/material.dart';
import 'package:pilot/dialogs/location_dialog.dart';
import 'package:pilot/geofinder/geofinder.dart';
import 'package:pilot/geolocation/geolocation.dart';
import 'package:url_launcher/url_launcher.dart';

class SenatorPage extends StatefulWidget {
  const SenatorPage({super.key});

  @override
  State<SenatorPage> createState() => _SenatorPageState();
}

class _SenatorPageState extends State<SenatorPage> {
  String release = "0.0.0";
  String name = "";
  String mandate = "";
  String club = "";
  String web = "";
  String photo = "";

  late Future<bool> _senatorFuture;

  @override
  void initState() {
    super.initState();
    _senatorFuture = _getSenator();
  }

  Future<bool> _getSenator() async {
    final geolocation = Geolocation();
    final location = await geolocation.getPositionFromLocation();
    if (location != null) {
      final geofinder = Geofinder();
      await geofinder.loadData("assets/json/districts.json");
      await geofinder.loadSenators("assets/json/senators.json");
      final properties = geofinder
          .getLocationProperties(Point(location.latitude, location.longitude));
      final senator = geofinder.findSenator(properties);
      if (senator != null) {
        if (mounted) {
          setState(() {
            name = senator['name'];
            mandate = senator['mandate'];
            club = senator['club'];
            web = senator['web'];
            photo = senator['photo'];
            release = geofinder.getReleaseDate();
          });
          return true;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        color: Color(0xff003876),
        onRefresh: () async {
          setState(() {
            _senatorFuture = _getSenator();
          });
          await _senatorFuture;
        },
        child: FutureBuilder(
          future: _senatorFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Color(0xff003876),
                ),
              );
            }

            if (snapshot.hasData && snapshot.data == false) {
              Future.microtask(() {
                if (context.mounted) {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) => LocationDialog(
                      title: "Nelze najít senátora",
                      text:
                          "Nelze najít senátora. Zkontrolujte, zda máte zapnutou polohu, popřípadě povolte aplikaci přístup k polohovým službám.",
                    ),
                  );
                }
              });

              return SizedBox();
            }

            return ListView(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 60),
                      child: Center(
                        child: CircleAvatar(
                          radius: 80,
                          backgroundColor: Color(0xff003876),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: ClipOval(
                              child: Image.asset(photo),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(name,
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff003876))),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text("($mandate)",
                          style: TextStyle(
                              fontSize: 18, color: Color(0xff003876))),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 75),
                      child: Text("Poslanecký klub",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff003876))),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(club,
                          style: TextStyle(
                              fontSize: 18, color: Color(0xff003876))),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 100),
                      child: GestureDetector(
                        onTap: () async {
                          await launchUrl(Uri.parse(web));
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Color(0xff003876),
                              borderRadius: BorderRadius.circular(8)),
                          child: Text(
                            "Zjistit více informací",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 225),
                      child: Text(
                        "Aktualizace: $release",
                        style: TextStyle(
                          color: Color(0xff003876),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

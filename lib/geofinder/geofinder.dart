import 'dart:convert';
import 'package:flutter/services.dart';

class Point {
  final double x, y;
  Point(this.x, this.y);
}

class Geofinder {
  Map<String, dynamic> _data = {};
  Map<String, dynamic> _senators = {};
  List<List<dynamic>> features = [];

  Future<void> loadData(String path) async {
    String data = await rootBundle.loadString(path);
    _data = json.decode(data);
  }

  Future<void> loadSenators(String path) async {
    String data = await rootBundle.loadString(path);
    _senators = json.decode(data);
  }

  Map<String, dynamic>? findSenator(Map<String, dynamic>? properties) {
    if (properties == null) return null;

    final int district = int.parse(properties['OBVOD']);
    for (var senator in _senators['senators']) {
      if (senator['district'] == district) {
        return senator;
      }
    }
    return null;
  }

  Map<String, dynamic>? getLocationProperties(Point coordinates) {
    final features = _getFeatures();

    for (var i = 0; i < features.length; i++) {
      final featureCoordinates = _getFeatureCoordinates(i);
      if (featureCoordinates.isEmpty) {
        continue;
      }

      List<Point> points = [];
      for (var j = 0; j < featureCoordinates.length; j++) {
        points.add(Point(featureCoordinates[j][1].toDouble(),
            featureCoordinates[j][0].toDouble()));
      }

      if (_isPointInPolygon(coordinates, points)) {
        return _getFeatureProperties(i);
      }
    }

    return null;
  }

  bool _isPointInPolygon(Point point, List<Point> polygon) {
    bool inside = false;
    int n = polygon.length;
    int j = n - 1;

    for (int i = 0; i < n; i++) {
      double xi = polygon[i].x, yi = polygon[i].y;
      double xj = polygon[j].x, yj = polygon[j].y;

      bool intersect = ((yi > point.y) != (yj > point.y)) &&
          (point.x < (xj - xi) * (point.y - yi) / (yj - yi) + xi);

      if (intersect) inside = !inside;
      j = i;
    }

    return inside;
  }

  List<dynamic> _getFeatures() {
    return _data['features'];
  }

  Map<String, dynamic> _getFeatureProperties(int index) {
    return _data['features'][index]['properties'];
  }

  List<dynamic> _getFeatureCoordinates(int index) {
    return _data['features'][index]['geometry']['coordinates'][0];
  }

  String getReleaseDate() {
    return _senators["releaseDate"];
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ns_firebase_utils/constants.dart';
import 'package:ns_firebase_utils/utils/logs.dart';

/// extension methods for Map
///
extension MapFirestoreExtensions on Map {
  /// Reads a [key] value of [Timestamp] type from [Map].
  ///
  /// If value is NULL or not [Timestamp] type return default NULL
  ///.
  Timestamp getTimestamp(String key) {
    Map data = this;
    if (data == null) {
      data = defaultMap;
    }
    if (data.containsKey(key) && data[key] is Timestamp) {
      return data[key];
    }
    nsfLogs("Map.getTimeStamp[$key] has incorrect data : ${data[key]}");
    return null;
  }

  /// Reads a [key] value of [GeoPoint] type from [Map].
  ///
  /// If value is NULL or not [GeoPoint] type return default GeoPoint
  ///.

  GeoPoint getGeoPoint(String key) {
    Map data = this;
    if (data == null) {
      data = {};
    }
    if (data.containsKey(key) && data[key] is GeoPoint) {
      return data[key];
    }
    nsfLogs("Map.getGeoPoint[$key] has incorrect data : ${data[key]}");
    return defaultGeoPoint;
  }
}

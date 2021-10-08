import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ns_firebase_utils/constants.dart';

import '../src.dart';

/// extension methods for Map
///
extension MapFirestoreExtensions on Map {
  /// Reads a [key] value of [Timestamp] type from [Map].
  ///
  /// If value is NULL or not [Timestamp] type return default NULL
  ///.
  Timestamp? getTimestamp(String key) {
    if (containsKey(key) && this[key] is Timestamp) {
      return this[key];
    }
    errorLogsNS("Map.getTimeStamp[$key] has incorrect data : ${this[key]}");
    return null;
  }

  /// Reads a [key] value of [GeoPoint] type from [Map].
  ///
  /// If value is NULL or not [GeoPoint] type return default GeoPoint
  ///.

  GeoPoint? getGeoPoint(String key) {
    if (containsKey(key) && this[key] is GeoPoint) {
      return this[key];
    }
    errorLogsNS("Map.getGeoPoint[$key] has incorrect data : ${this[key]}");
    return defaultGeoPoint;
  }
}

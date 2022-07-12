import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

SetOptions mergeOption = SetOptions(
  merge: true,
);

final mockFirestoreInstance = FakeFirebaseFirestore();

class FirebaseGroupApi {
  final String collection;
  late Query<Map<String, dynamic>> groupQuery;
  final bool isTest;

  FirebaseGroupApi(
    this.collection, {
    this.isTest: false,
  }) {
    if (isTest) {
      groupQuery = mockFirestoreInstance.collectionGroup(collection);
    } else {
      groupQuery = FirebaseFirestore.instance.collectionGroup(collection);
    }
  }
}

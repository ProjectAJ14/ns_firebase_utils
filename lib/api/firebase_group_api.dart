import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

SetOptions mergeOption = SetOptions(
  merge: true,
);

final mockFirestoreInstance = FakeFirebaseFirestore();

class FirebaseGroupApi {
  final String collection;
  late Query<Map<String, dynamic>> query;
  final bool isTest;

  FirebaseGroupApi(
    this.collection, {
    this.isTest: false,
  }) {
    if (isTest) {
      query = mockFirestoreInstance.collectionGroup(collection);
    } else {
      query = FirebaseFirestore.instance.collectionGroup(collection);
    }
  }
}

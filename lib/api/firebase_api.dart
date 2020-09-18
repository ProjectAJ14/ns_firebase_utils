import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';

SetOptions mergeOption = SetOptions(
  merge: true,
);

class FirebaseApi {
  final String path;
  CollectionReference ref;
  final bool isTest;

  FirebaseApi(this.path, {this.isTest: false}) {
    if (isTest)
      ref = MockFirestoreInstance().collection(path);
    else
      ref = FirebaseFirestore.instance.collection(path);
  }

  Future<QuerySnapshot> getDataCollection() {
    return ref.get();
  }

  Stream<QuerySnapshot> streamDataCollection() {
    return ref.snapshots();
  }

  Future<DocumentSnapshot> getDocumentById(String id) {
    return ref.doc(id).get();
  }

  DocumentReference getDocumentRef(String id) {
    return ref.doc(id);
  }

  Future<void> removeDocument(String id) {
    return ref.doc(id).delete();
  }

  Future<void> addDocument({String id, Map<String, dynamic> data}) {
    return ref.doc(id).set(data);
  }

  WriteBatch batch() {
    if (isTest)
      return MockFirestoreInstance().batch();
    else
      return FirebaseFirestore.instance.batch();
  }

  Future<void> updateDocument({String id, Map<String, dynamic> data}) {
    return ref.doc(id).set(
          data,
          mergeOption,
        );
  }
}

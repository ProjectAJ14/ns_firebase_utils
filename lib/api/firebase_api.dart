import 'package:cloud_firestore/cloud_firestore.dart';

SetOptions mergeOption = SetOptions(
  merge: true,
);

class FirebaseApi {
  final String path;
  CollectionReference ref;

  FirebaseApi(this.path) {
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

  Future<void> updateDocument({String id, Map<String, dynamic> data}) {
    return ref.doc(id).set(
          data,
          mergeOption,
        );
  }
}

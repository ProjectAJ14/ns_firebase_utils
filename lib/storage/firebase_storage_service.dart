import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:ns_firebase_utils/utils/logs.dart';

class FirebaseStorageService {
  static Future<String> uploadFile(
    File file,
    String path, {
    Map<String, String> customMetadata = const {},
  }) async {
    Reference storageReference = FirebaseStorage.instance.ref().child(path);

    final UploadTask uploadTask = storageReference.putFile(
      file,
      SettableMetadata(
        contentLanguage: 'en',
        customMetadata: customMetadata,
      ),
    );

    TaskSnapshot snapshot = await uploadTask.whenComplete(() {
      nsfLogs("uploadTask whenComplete");
    });

    nsfLogs("uploadTask whenComplete[${snapshot.state.index}]");

    String fileURL = await storageReference.getDownloadURL();
    nsfLogs("uploadFile fileURL: $fileURL");
    return fileURL;
  }
}

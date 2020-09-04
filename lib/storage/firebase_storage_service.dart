import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:ns_firebase_utils/utils/logs.dart';
import 'package:ns_firebase_utils/utils/nsf_exception.dart';

class FirebaseStorageService {
  static Future<String> uploadFile(
    File file,
    String path, {
    Map<String, String> customMetadata = const {},
  }) async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(path);

    final StorageUploadTask uploadTask = storageReference.putFile(
      file,
      StorageMetadata(
        contentLanguage: 'en',
        customMetadata: customMetadata,
      ),
    );

    await uploadTask.onComplete.catchError((error) {
      throw NSFException.defaultException(error);
    }).then((data) {
      nsfLogs("uploadFile Complete");
    });

    String fileURL = await storageReference.getDownloadURL();
    nsfLogs("uploadFile fileURL: $fileURL");
    return fileURL;
  }
}

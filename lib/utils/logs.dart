import 'package:ns_firebase_utils/src.dart';

class NSFLogTag {
  static const String NSF = 'NSF';
}

nsfLogs(
  Object object, {
  String tag = NSFLogTag.NSF,
}) =>
    logMessage('$object', tag);

///print logs even if the content more then log buffer size
///
logMessage(String message, String tag) {
  if (!NSFirebase.instance.printLogs) return;
  int maxLogSize = 1000;
  for (int i = 0; i <= message.length / maxLogSize; i++) {
    int start = i * maxLogSize;
    int end = (i + 1) * maxLogSize;
    end = end > message.length ? message.length : end;
    print("$tag : ${message.substring(start, end)}");
  }
  print('\n');
}
